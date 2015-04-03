# FasterCSV library for ease of parsing, handles commas nested inside quotes too
require 'csv'

# Initialize timestamp for logging purposes
initial_time = Time.now

# Seasonal lookup based on passed in CSV file
seasons = {
	:"1" => 'January',
	:"2" => 'Spring',
	:"6" => 'Summer',
	:"8" => 'Fall'
}

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

# Open file for logging
File.open("#{Rails.root.to_s}/data/#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w') do |log|
	# Go through every file inside data/csv to load into database
	# Sorted so earlier semesters are done first
	Dir.entries("#{Rails.root.to_s}/data/csv/").sort_by(&:to_s).each do |file|
		# Skip these directory contents
		if file == '.' or file == '..'
			next
		end
		# Log which file we're currently working with
		log.puts "Loading #{file}"
		# Grab the semester number, i.e. 1158
		number = file[2..5]
		# Attempt to find the matching semester by number
		semester = Semester.find_by(:number => number.to_i)

		# If semester is not found, then we need to create it
		if semester
			mode = 'update'
		else
			mode = 'create'
			# Log that we're creating a new semester
			log.puts "Creating Semester: #{number}"
			# Create semester with following options
			semester = Semester.create({
				:number => number, # Pass in number, i.e. 1158
				:season => seasons[number[-1].to_sym], # Season - see mapping above
				:year => "20#{number[1..2]}" # The year is actually in the number
			})
		end

		# Actually start parsing through the CSV file now
		File.open("#{Rails.root.to_s}/data/csv/#{file}").each do |line|
			# Try to catch CSV malformed lines and gracefully log them
			begin
				# CSV will parse each line into array into data
				data = CSV.parse_line(line)
				# Ignore the first line
				if data[0] == 'ClassNumber'
					next
				end

				# Attempt to find corresponding subdepartment by mnemonic
				subdepartment = Subdepartment.find_by(:mnemonic => data[1])

				# If no subdepartment exists, need to create
				unless subdepartment
					log.puts "Creating Subdepartment: #{data[1]}"
					# Only pass in mnemonic
					subdepartment = Subdepartment.create({
						:mnemonic => data[1] # i.e. "CS"
					})
				end

				# Attempt to find course by course_number and matching subdepartment
				course = Course.find_by(:course_number => data[2], :subdepartment_id => subdepartment.id)

				# If no course exists, need to create
				unless course
					log.puts "Creating Course: #{data[1]} #{data[2]}"
					# Only pass in title, course_number, and subdepartment
					course = Course.create({
						:title => data[9], # May change from semester to semester
						:course_number => data[2].to_i, # i.e. 2150
						:subdepartment_id => subdepartment.id # corresponding subdepartment
					})
				end

				# If course already exists, then check if title might've changed
				if course.title != data[9]
					# Log old title vs new title for the same course
					log.puts "Mismatch Course Title: #{subdepartment.mnemonic} #{course.course_number}"
					log.puts "#{course.title} vs #{data[9]}"
					# Set course title to new content
					course.title = data[9]
					# This actually won't save if new title is blank - keep old title
					course.save
				end

				# Split input professor string by comma in case of multiple professors
				# data[6] might be "John Smith" or "John Smith, Nancy Jones"				
				professors = data[6].split(',').map do |professor|
					# professor might be "John Smith" or "John Adam Jones"
					# Split each full name into components by space
					names = professor.split(' ')

					if names[0] == 'Staff'
						Professor.find_by(:first_name => 'Staff')
					else
						# Search database by first name, last name
						# First name should be first element, last name should be last element
						possible_professors = Professor.where(:first_name => names[0], :last_name => names[-1])

						# No professors found by that name
						if possible_professors.count == 0
							log.puts "Creating Professor #{professor}"
							# For now, create with only first and last name
							Professor.create({
								:first_name => names[0],
								:last_name => names[-1]
							})
						else
							# Check how many other courses in the same subdepartment this professor has taught
							# Each element in course_counts corresponds to professor courses taught in listed subdepartment
							course_counts = []
							possible_professors.each do |possibility|
								# Count each possible professor's courses that match the current subdepartment
								course_counts << possibility.courses_in_subdepartment(subdepartment).count
							end

							# Find max in course_counts
							max = course_counts.max

							# If one professor was returned anyway and has taught in this section, then that's correct
							if max != 0 and possible_professors.count == 1
								possible_professors[0]
							# If no professor has taught in this subdepartment, then create new professor
							elsif max == 0
								# Create new professor
								Professor.create({
									:first_name => names[0],
									:last_name => names[-1]
								})
							else
								# Log that we now look to see number of courses taught
								log.puts "Duplicate Professor #{professor} for #{semester.year} #{semester.season} #{subdepartment.mnemonic} #{course.course_number} - performing further analysis"
								# Log all matching possible_professors for future reference
								possible_professors.each_index do |index|
									possibility = possible_professors[index]
									most_taught_subdepartment = possibility.most_taught_subdepartment
									if most_taught_subdepartment
										log.puts "#{index}: #{possibility.id} - Taught #{course_counts[index]} courses in #{subdepartment.mnemonic}, mostly taught #{possibility.courses_in_subdepartment(most_taught_subdepartment).count} courses in #{most_taught_subdepartment.mnemonic}"
									else
										log.puts "#{index}: #{possibility.id} - Taught no courses"
									end
								end

								# Choose professor that taught most courses in same subdepartment
								decision = possible_professors[course_counts.index(max)]
								log.puts "Choosing #{decision.id} with #{max} courses taught"

								decision
							end
						end
					end
				end
				

				# Split times string, i.e. "TuTh 12:30PM - 1:45PM"
				# First split by space
				times = data[7].split(' ')
				# Split first component ("TuTh") by every two characters
				day_times = times[0].scan(/.{2}/).map do |day|
					# If day was TBA
					if day == 'TB'
						# Find the pre-existing blank DayTime
						day_time = DayTime.find_by(:day => '')
						# If blank DayTime is found, assign
						if day_time
							day_time
						# Else, create blank DayTime
						else
							DayTime.create({
								:day => '',
								:start_time => '',
								:end_time => ''
							})
						end
					else
						# Parse in "12:30PM" and convert to "12:30"
						# Takes in "6:00PM" and returns "18:00"
						start_time = Time.parse(times[1]).strftime("%H:%M")
						end_time = Time.parse(times[3]).strftime("%H:%M")
						# Attempt to find corresponding DayTime in database
						day_time = DayTime.find_by(:day => day, :start_time => start_time, :end_time => end_time)
						# If exists, then return it
						if day_time
							day_time
						# If not, then create it
						else
							log.puts "Creating DayTime #{day} #{start_time} - #{end_time}"
							DayTime.create({
								:day => day,
								:start_time => start_time,
								:end_time => end_time
							})
						end
					end
				end

				# Find matching location, i.e. "Wilson Hall 301"
				location = Location.find_by(:location => data[8])

				# If not found, then create it
				unless location
					log.puts "Creating Location #{data[8]}"
					location = Location.create(:location => data[8])
				end

				# Finally, create section
				section = Section.create({
					:sis_class_number => data[0],
					:section_number => data[3],
					:topic => data[10],
					:units => data[5],
					:capacity => data[13],
					:section_type => data[4],
					:course_id => course.id,
					:semester_id => semester.id
				})

				# Link professors and sections
				professors.each do |professor|
					SectionProfessor.create({
						:section_id => section.id,
						:professor_id => professor.id
					})
				end

				# Bind day_times and sections with locations
				day_times.each do |day_time|
					ActiveRecord::Base.connection.execute("INSERT INTO day_times_sections (day_time_id, section_id, location_id) VALUES (#{day_time.id}, #{section.id}, #{location.id})")
				end
			# If CSV was malformed, log it
			rescue CSV::MalformedCSVError => er
				log.puts er.message
				log.puts "#{file} and #{line}"
			end
		end

		# Log current running time
		log.puts "Finished #{semester.season} #{semester.year} in #{(Time.now - initial_time) / 60} minutes"
	end
	# Log total running time
	log.puts "Total Runtime: #{(Time.now - initial_time) / 60} minutes"
end