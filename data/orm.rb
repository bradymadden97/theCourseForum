# Author AlanWei

# IMPORTANT
# Before you load in semester, you might want to backup the current state of the database before you load in Lou's data, so you can easily reset to that state
# shell.sql contains just schema information if you want to quickly reset with
# mysql -u root thecourseforum_development < shell.sql

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

	# Initalize array of professors we want to lookup later using LDAP
	ldap_professors = []

	# Log which file we're currently working with
	log.puts "Loading #{file}"

	# Attempt to find the matching semester by number
	semester = Semester.find_by(:number => number.to_i)

	# If semester is found, we are UPDATING semester contents
	# Not done yet (mode is not used anywhere)
	if semester
		puts "Previous Semester Detected - Destructive update? (Wipe sections in semester) y/n"
		answer = gets.chomp
		if answer == 'y'
			Section.destroy_all(:semester_id => semester.id)
			mode = 'recreate'
		else
			mode = 'update'
			section_ids = Section.where(:semester_id => semester.id).ids
		end
	# If semester is not found, then create - we are loading in new semester
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

	log.puts "Starting #{semester.season} #{semester.year} with mode #{mode}"

	# Actually start parsing through the CSV file now
	File.open("#{Rails.root.to_s}/data/csv/#{file}").each do |line|
		# Try to catch CSV malformed lines and gracefully log them
		begin
			# CSV will parse each line into array into data
			data = CSV.parse_line(line)
			# Ignore the first line
			if data[0] == 'ClassNumber'
				next
			# Store data into easily accessible object - Array -> Hash
			else
				data = {
					:sis_class_number => data[0].to_i,
					:mnemonic => data[1],
					:course_number => data[2],
					:section_number => data[3].to_i,
					:section_type => data[4],
					:units => data[5],
					:professors => data[6],
					:days => data[7],
					:location => data[8],
					:title => data[9],
					:topic => data[10],
					:status => data[11],
					:enrollment => data[12],
					:capacity => data[13].to_i,
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

			# If course exists
			if course
				# If title doesn't match, and we are updating this semester
				if course.title != data[:title] and mode == 'update'
					# Log old title vs new title for the same course
					log.puts "Mismatch Course Title: #{subdepartment.mnemonic} #{course.course_number}"
					log.puts "#{course.title} vs #{data[:title]}"
					# Set course title to new content
					course.update(:title => data[:title])
				end
			# If no course exists, need to create
			else
				log.puts "Creating Course: #{data[:mnemonic]} #{data[:course_number]}"
				# Only pass in title, course_number, and subdepartment
				course = subdepartment.courses.create({
					:title => data[:title], # May change from semester to semester
					:course_number => data[:course_number] # i.e. 2150
				})
			end

			# Split input professor string by comma in case of multiple professors
			# data[:professors] might be "John Smith" or "John Smith, Nancy Jones"
			professors = data[:professors].split(',').map do |professor|
				# professor might be "John Smith" or "John Adam Jones" or " Nancy Jones"
				# Get rid of whitespace in front of second professor name if it exists, i.e. " Nancy Jones"
				professor = professor.strip
				# Split each full name into components by space
				names = professor.split(' ')

				# If Staff, then we manually handle this case
				if names[0] == 'Staff'
					# Find Staff professor, if doesn't exist, then create
					Professor.find_by(:first_name => 'Staff') or Professor.create(:first_name => 'Staff')
				else
					# Search database by first name, last name
					# First name should be first element, last name should be last element
					possible_professors = Professor.where(:first_name => names[0], :last_name => names[-1])

					# If no professor found by name, then create new one
					if possible_professors.count == 0
						log.puts "Creating Professor #{professor}"
						# For now, create with only first and last name
						Professor.create({
							:first_name => names[0],
							:last_name => names[-1]
						})
					# Otherwise, we examine loop - no matter if we found one or multiple matches
					# We do same analysis for one vs multiple match because of differing circumstances
					else
						# Initialize count for how many courses a potential professor has taught in this subdepartment (that we are analyzing)
						max = 0
						# Initialize our final machine algorithm decision
						decision = nil
						# Loop through all possibilities, whether one professor or multiple
						possible_professors.each do |possibility|
							# If professor has previously taught this course, then most likely correct - what are the chances that a new professor with the same name comes in and teaches the same course?
							if possibility.courses.uniq.include?(course)
								# If, however, the above scenario actually happened and two professors by the same name has taught this course
								if decision
									# Let's log this scenario
									log.puts "Duplicate match: #{possibility.full_name} #{data[:sis_class_number]} Same Name Same Course"
									# Only store full name of professor for later lookup if we don't already log it
									unless ldap_professors.include?(professor)
										ldap_professors << professor
									end
								# Most likely, we only have one match (previously taught this course) and we assign our decision to this possibility
								else
									decision = possibility
								end
							# Next, we begin considering how many courses each possible professor has taught in the target subdepartment
							# If no professor has ever taught in this subdepartment, then count will never be greater than initial max (0) so therefore we probably need a new professor
							# Works no matter if possible_professors found one or multiple matches
							elsif possibility.courses_in_subdepartment(subdepartment).count > max
								max = possibility.courses_in_subdepartment(subdepartment).count
								decision = possibility
							end
							# Notice that we don't have an else clause here - it is fully possible that our automated decision matrix does not find a match
						end

						# If our automated decision matrix found a match, then we probably want to return it
						if decision
							# If total possibilities were greater than one, then that means our decision matrix compared course counts in target subdepartment (because the other clause of same name same course is really rare)
							if possible_professors.count > 1
								# Let's log those offending scenarios for later lookup
								unless ldap_professors.include?(professor)
									log.puts "Duplicate match: #{decision.id} #{decision.full_name} Same Name Different Courses"
									ldap_professors << professor
								end
							end
						# Only goes here if no professor has ever taught that course or that subdepartment
						else
							# Create a new professor!
							decision = Professor.create({
								:first_name => names[0],
								:last_name => names[-1]
							})
							# Remember, we only got here because professor lookup returned a few candidates, yet none of them matched, so we probably want to double check this later via LDAP
							unless ldap_professors.include?(professor)
								log.puts "Creating new duplicate professor #{decision.id} #{decision.full_name} #{data[:sis_class_number]} Same Name No Matches"
								ldap_professors << professor
							end
						end
						decision
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

			# Test case for multiple locations... otherwise we don't need our triple join table (or even location model)
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

			# Attempt to find pre-existing section by sis_class_number and semester_id
			section = Section.find_by(:sis_class_number => data[:sis_class_number], :semester_id => semester.id)

			# If we found a semester
			if section
				# Only if user selected "update" mode in the beginning
				if mode == 'update'
					# Remove from master listings; i.e. we found a match in CSV - used to delete database sections without CSV match later
					section_ids.delete(section.id)

					# Update section only if some attributes have changed
					if section.section_number != data[:section_number] or section.topic.to_s != data[:topic] or section.units != data[:units] or section.capacity != data[:capacity] or section.section_type != data[:section_type]
						# Find all differing fields
						differing = []
						# Loop through fields
						[:section_number, :topic, :units, :capacity, :section_type].each do |sym|
							# If previous content does not match new content
							if section.send(sym) != data[sym]
								differing << sym
							end
						end

						# Fringe case for nil topics
						if differing.include?(:topic) and section.topic.to_s == data[:topic]
							differing.delete(:topic)
						end

						log.print "Updating Section Metadata ID: #{section.id} SIS: #{section.sis_class_number}"
						differing.each do |sym|
							log.print " #{sym.to_s}: #{section.send(sym)} vs #{data[sym]},"
						end
						log.puts
						# Update the section with new attributes
						section.update({
							:section_number => data[:section_number],
							:topic => data[:topic],
							:units => data[:units],
							:capacity => data[:capacity],
							:section_type => data[:section_type],
						})
					end

					# If day_times or locations have changed
					if section.day_times != day_times or section.locations[0] != location
						log.print "Updating Section DayTimes ID: #{section.id} SIS: #{section.sis_class_number}"
						# Find all new day_times through array subtraction
						new_day_times = day_times - section.day_times
						old_day_times = section.day_times - day_times
						# Delete current relationships between section and day_times
						section.day_times.each do |day_time|
							if old_day_times.include?(day_time)
								log.print " removing #{day_time.day} #{day_time.start_time} - #{day_time.end_time} from section"
							end
							ActiveRecord::Base.connection.execute("DELETE FROM day_times_sections WHERE section_id = #{section.id} AND day_time_id = #{day_time.id}")
						end
						# Re-insert new relationships between section and day_times
						day_times.each do |day_time|
							# If new day_time was found
							if new_day_times.include?(day_time)
								log.print " adding #{day_time.day} #{day_time.start_time} - #{day_time.end_time}"
							end
							ActiveRecord::Base.connection.execute("INSERT INTO day_times_sections (day_time_id, section_id, location_id) VALUES (#{day_time.id}, #{section.id}, #{location.id})")
						end
						log.puts
						# Flag all schedules associated with this section if location or day_times has changed
						section.schedules.each do |schedule|
							schedule.update(:flagged => true)
						end
					end

					# If professors have changed - check only by name so we don't inadvertently update duplicates
					if section.professors.map(&:full_name).sort != professors.map(&:full_name).sort
						log.print "Updating Section Professors ID: #{section.id} SIS: #{section.sis_class_number}"
						# Delete all current links between section and professor
						section.section_professors.each do |section_professor|
							log.print " removing #{section_professor.professor.full_name}"
							SectionProfessor.destroy(section_professor)
						end
						# Recreate links with new data
						professors.each do |professor|
							log.print " adding #{professor.full_name}"
							SectionProfessor.create({
								:section_id => section.id,
								:professor_id => professor.id
							})
						end
						log.puts
					end
				# Otherwise, section already exists - something went wrong
				else
					puts "Fatal Error! Preexisting Section #{sis_class_number} in #{semester.season} #{semester.year}"
					break
				end
			# Otherwise, we create the semester
			else
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

				# Bind day_times and sections with locations
				day_times.each do |day_time|
					ActiveRecord::Base.connection.execute("INSERT INTO day_times_sections (day_time_id, section_id, location_id) VALUES (#{day_time.id}, #{section.id}, #{location.id})")
				end

				# Link professors and sections
				professors.each do |professor|
					SectionProfessor.create({
						:section_id => section.id,
						:professor_id => professor.id
					})
				end
			end

		# If CSV was malformed, log it
		rescue CSV::MalformedCSVError => er
			log.puts er.message
			log.puts "#{file} and #{line}"
		end
	end

	if mode == 'update'
		# If mode was update, then we delete all sections in database without a CSV match
		section_ids.each do |section_id|
			section = Section.find(section_id)
			section.day_times.each do |day_time|
				log.puts "Deleting Section ID: #{section.id} SIS: #{section.sis_class_number}"
				ActiveRecord::Base.connection.execute("DELETE FROM day_times_sections WHERE section_id = #{section.id} AND day_time_id = #{day_time.id}")
			end
			Section.destroy(section)
		end
	end

	# Log current running time
	log.puts "Finished #{semester.season} #{semester.year} in #{(Time.now - csv_time) / 60} minutes"
	puts "Finished #{semester.season} #{semester.year} in #{(Time.now - csv_time) / 60} minutes"

	# Let's uniq ldap_professors just in case some duplicates snuck in (shouldn't be possible, but can't hurt)
	ldap_professors = ldap_professors.uniq
	# Open file to log all professors for later lookup
	# ldap_duplicates_1158 for Fall 2015 for example
	ldap = File.open("#{Rails.root.to_s}/data/ldap_duplicates_#{number}", 'w')
	for professor in ldap_professors
		# Log all professors for later lookup into file
		ldap.puts professor
	end
	# Close file (flush buffer)
	ldap.close

	# Ask if we want to segue automatically into professor lookup (LDAP)
	puts "Perform LDAP lookups? #{ldap_professors.count} total? y/n "
	if gets.chomp == 'y'
		load('data/professor.rb')
	end

	# Close log
	log.close
end

# Log total running time
puts "Total Runtime: #{(Time.now - total_time) / 60} minutes"

# IMPORTANT
# After you run this file for one semester, you probably want to backup the current state of the database before you perform LDAP lookups, so you can easily reset to that state
# mysqldump -u root thecourseforum_development > ldap1158.sql