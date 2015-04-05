# FasterCSV library for ease of parsing, handles commas nested inside quotes too
require 'csv'

# Initialize timestamp for logging purposes
total_time = Time.now

# Seasonal lookup based on passed in CSV file
seasons = {
	:"1" => 'January',
	:"2" => 'Spring',
	:"6" => 'Summer',
	:"8" => 'Fall'
}

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

# Go through every file inside data/csv to load into database
# Sorted so earlier semesters are done first
Dir.entries("#{Rails.root.to_s}/data/csv/").sort_by(&:to_s).each do |file|
	# Skip these directory contents
	if file == '.' or file == '..'
		next
	end

	# Initialize timestamp per csv
	csv_time = Time.now

	# Grab the semester number, i.e. 1158
	number = file[2..5]

	# Open log for each CSV
	log = File.open("#{Rails.root.to_s}/data/lou#{number}_#{csv_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

	# Open ldap log for lookups later
	ldap_professors = []

	# Log which file we're currently working with
	log.puts "Loading #{file}"

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

	log.puts "Starting #{semester.season} #{semester.year}"

	# Actually start parsing through the CSV file now
	File.open("#{Rails.root.to_s}/data/csv/#{file}").each do |line|
		# Try to catch CSV malformed lines and gracefully log them
		begin
			# CSV will parse each line into array into data
			data = CSV.parse_line(line)
			# Ignore the first line
			if data[0] == 'ClassNumber'
				next
			else
				data = {
					:sis_class_number => data[0],
					:mnemonic => data[1],
					:course_number => data[2],
					:section_number => data[3],
					:section_type => data[4],
					:units => data[5],
					:professors => data[6],
					:days => data[7],
					:location => data[8],
					:title => data[9],
					:topic => data[10],
					:status => data[11],
					:enrollment => data[12],
					:capacity => data[13],
					:waitlist => data[14]
				}
			end

			# Attempt to find corresponding subdepartment by mnemonic
			subdepartment = Subdepartment.find_by(:mnemonic => data[:mnemonic])

			# If no subdepartment exists, need to create
			unless subdepartment
				log.puts "Creating Subdepartment: #{data[:mnemonic]}"
				# Only pass in mnemonic
				subdepartment = Subdepartment.create({
					:mnemonic => data[:mnemonic] # i.e. "CS"
				})
			end

			# Attempt to find course by course_number and matching subdepartment
			course = subdepartment.courses.find_by(:course_number => data[:course_number])

			# If course exists, title doesn't match, and we are updating this semester
			if course
				if course.title != data[:title] and mode == 'update'
					# Log old title vs new title for the same course
					log.puts "Mismatch Course Title: #{subdepartment.mnemonic} #{course.course_number}"
					log.puts "#{course.title} vs #{data[:title]}"
					# Set course title to new content
					course.title = data[:title]
					# This actually won't save if new title is blank - keep old title
					course.save
				end
			# If no course exists, need to create
			else
				# log.puts "Creating Course: #{data[:mnemonic]} #{data[:course_number]}"
				# Only pass in title, course_number, and subdepartment
				course = subdepartment.courses.create({
					:title => data[:title], # May change from semester to semester
					:course_number => data[:course_number] # i.e. 2150
				})
			end

			# Split input professor string by comma in case of multiple professors
			# data[:professors] might be "John Smith" or "John Smith, Nancy Jones"				
			professors = data[:professors].split(',').map do |professor|
				professor = professor.strip
				# professor might be "John Smith" or "John Adam Jones"
				# Split each full name into components by space
				names = professor.split(' ')

				if names[0] == 'Staff'
					# Find Staff professor, if doesn't exist, then create
					Professor.find_by(:first_name => 'Staff') or Professor.create(:first_name => 'Staff')
				else
					# Search database by first name, last name
					# First name should be first element, last name should be last element
					possible_professors = Professor.where(:first_name => names[0], :last_name => names[-1])

					if possible_professors.count == 0
						# log.puts "Creating Professor #{professor}"
						# For now, create with only first and last name
						Professor.create({
							:first_name => names[0],
							:last_name => names[-1]
						})
					else
						# Count for courses taught in subdepartment
						max = 0
						decision = nil
						possible_professors.each do |possibility|
							# If professor has previously taught this course, then most likely correct
							if possibility.courses.uniq.include?(course)
								# NO LDAP
								# ldap_professors << possibility
								if decision
									# log.puts "Duplicate match: #{possibility.full_name} #{data[:sis_class_number]} Same Name Same Course"
									ldap_professors << professor
								else
									decision = possibility
								end
							elsif possibility.courses_in_subdepartment(subdepartment).count > max
								max = possibility.courses_in_subdepartment(subdepartment).count
								decision = possibility
							end
						end

						# If we found a match, return it
						if decision
							if possible_professors.count > 1
								unless ldap_professors.include?(professor)
									ldap_professors << professor
									# log.puts "Duplicate match: #{decision.id} #{decision.full_name} Same Name Different Courses"
								end
								ldap_professors << professor
								decision
							else
								decision
							end
						else
							decision = Professor.create({
								:first_name => names[0],
								:last_name => names[-1]
							})
							# YES LDAP
							unless ldap_professors.include?(professor)
								ldap_professors << professor
								# log.puts "Creating new duplicate professor #{decision.id} #{decision.full_name} #{data[:sis_class_number]} Same Name No Matches"
							end
							decision
						end
					end
				end
			end
			

			# Split times string, i.e. "TuTh 12:30PM - 1:45PM"
			# First split by space
			times = data[:days].split(' ')
			# Split first component ("TuTh") by every two characters
			day_times = times[0].scan(/.{2}/).map do |day|
				# If day was TBA
				if day == 'TB'
					# If day_time is found (not nil) then return day_time, else return created day_time
					DayTime.find_by(:day => '') or DayTime.create({
						:day => '',
						:start_time => '',
						:end_time => ''
					})
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
						# log.puts "Creating DayTime #{day} #{start_time} - #{end_time}"
						DayTime.create({
							:day => day,
							:start_time => start_time,
							:end_time => end_time
						})
					end
				end
			end

			if data[:location].split(',').count > 1
				log.puts "Multiple Location #{data[:location]} #{data[:sis_class_number]}"
			end
			# Find matching location, i.e. "Wilson Hall 301"
			location = Location.find_by(:location => data[:location])

			# If not found, then create it
			unless location
				# log.puts "Creating Location #{data[:location]}"
				location = Location.create(:location => data[:location])
			end

			# Finally, create section
			section = Section.create({
				:sis_class_number => data[:sis_class_number],
				:section_number => data[:section_number],
				:topic => data[:topic],
				:units => data[:units],
				:capacity => data[:capacity],
				:section_type => data[:section_type],
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
	log.puts "Finished #{semester.season} #{semester.year} in #{(Time.now - csv_time) / 60} minutes"
	puts "Finished #{semester.season} #{semester.year} in #{(Time.now - csv_time) / 60} minutes"

	ldap_professors = ldap_professors.uniq
	ldap = File.open("#{Rails.root.to_s}/data/ldap1158", 'w')
	for professor in ldap_professors
		ldap.puts professor
	end
	ldap.close
	puts "Perform LDAP lookups? #{ldap_professors.count} total? y/n "
	if gets.chomp == 'y'
		load('data/professor.rb')
	end

	log.close
end

# Log total running time
puts "Total Runtime: #{(Time.now - total_time) / 60} minutes"