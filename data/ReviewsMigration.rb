#Author Lawrence Hook

#### GOAL ####

# part1 - DUMP
# 	get columns 	all -- except course_id, professor_id
# 	get info 		course_mnemonic, course_number and professor_firstname, professor_lastname
# 	possible lead 	Serialize - ruby package
 
# part2 - IMPORT
# 	ascertain 		course_id, professor_id 	BY the info ^^
# 	consider 		section_id

#### END ####

# FasterCSV library for ease of parsing, handles commas nested inside quotes too
require 'csv'

puts "Dump or Import: (d/i)"
dori = gets.chomp

if dori == 'd'
	# DUMP reviews

	# For timing purposes
	start_time = Time.now

	# open log file
	log = File.open("#{Rails.root.to_s}/data/ReviewsDumpLog_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

	log.puts "DUMPING REVIEWS"

	# Open ReviewsDump.csv file
	reviews_dump = File.open("#{Rails.root.to_s}/data/ReviewsDump.csv", 'w')

	# Wanted information
	columns = [
		:id,
		:comment, 
		:course_professor_id,
		:student_id,
		:semester_id,
		:created_at,
		:updated_at,
		:professor_rating,
		:enjoyability,
		:difficulty,
		:amount_reading,
		:amount_writing,
		:amount_group,
		:amount_homework,
		:only_tests,
		:recommend,
		:ta_name
	]

	indirects = [
		:mnemonic,
		:course_number,
		:first_name,
		:last_name
	]


	# Header
	header = columns + indirects
	reviews_dump.puts header.join(',')

	# Get all reviews
	Review.all.each do |review|
		log.puts "Dumping review #{review.id}..."

		# Retrieve professor assoc. w/ review
		# 	While logging errors 
		if review.professor_id
			# Catch the case of a faulty professor id
			begin
				the_prof = Professor.find(review.professor_id)
			rescue ActiveRecord::RecordNotFound => er
				log.puts "\t#{er}"
				log.puts "\tCaused by professor_id #{review.professor_id}"
				log.puts "Skipping review #{review.id}"
				next
			end
		else
			log.puts "\tError: NO PROFESSOR"
			log.puts "Skipping review #{review.id}"
			next
		end
		
		# Retrieve course assoc. w/ review
		# 	while logging errors
		if review.course_id
			# Catch the case of faulty course id
			begin
				the_course = Course.find(review.course_id)
			rescue ActiveRecord::RecordNotFound => er
				log.puts "\t#{er}"
				log.puts "\tCaused by course_id #{course.professor_id}"
				log.puts "Skipping review #{review.id}"		
				next		
			end
		else
			# Review without a course is useless. There is one such review
			log.puts "\tError: NO COURSE"
			log.puts "Deleting review #{review.id}"
			review.delete
			next
		end
		
		the_subdep = Subdepartment.find(the_course.subdepartment_id)

		# Add the wanted columns of review
		reviews_info = columns.map do |column|
			review.send(column)
		end

		# Add the "indirect" data (i.e. course_mnemonic, course_number, professor_firstname, professor_lastname)
		reviews_info << the_subdep.mnemonic
		reviews_info << the_course.course_number
		reviews_info << the_prof.first_name
		reviews_info << the_prof.last_name

		# At last, write the info of each review to the ReviewsDump.csv file
		reviews_dump.puts reviews_info.to_csv(:quote_char => "'")

		log.puts "Finished review #{review.id}."

	end

	# Close log file
	log.puts "All done!"
	log.close

	# How long did this take?
	puts "Dump Reviews - Total Runtime: #{(Time.now - start_time) / 60} minutes"
	
elsif dori == 'i'
	# IMPORT reviews
	
	# For timing purposes
	start_time = Time.now

	# open log file
	log = File.open("#{Rails.root.to_s}/data/ReviewsDumpLog_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

	log.puts "IMPORTING REVIEWS"

	# Open ReviewsDump.csv file
	file = File.open("#{Rails.root.to_s}/data/ReviewsDump.csv", 'r')

	# Read in each line of the csv and create the review
	file.each do |line|
		# Try to catch CSV malformed lines and gracefully log them
		begin
			# Parse line into array
			raw = CSV.parse_line(line)

			# Skip the header line
			if raw[0] == 'id'
				next
			else
				data = {
					:id => raw[0],
					:comment => raw[1],
					:course_professor_id => raw[2],
					:student_id => raw[3],
					:semester_id => raw[4],
					:created_at => raw[5],
					:updated_at => raw[6],
					:professor_rating => raw[7],
					:enjoyability => raw[8],
					:difficulty => raw[9],
					:amount_reading => raw[10],
					:amount_writing => raw[11],
					:amount_group => raw[12],
					:amount_homework => raw[13],
					:only_tests => raw[14],
					:recommend => raw[15],
					:ta_name => raw[16],
					:course_mnemonic => raw[17],
					:course_number => raw[18],
					:professor_firstname => raw[19],
					:professor_lastname => raw[20]
				}
			end

			log.puts "Importing review #{data[:id]}..."

			# Try to find course
			course = Course.find_by_mnemonic_number(data[:course_mnemonic], data[:course_number])

			# Declare Professor
			professor = nil

			# Try to find professor
			Professor.where(:first_name => data[:professor_firstname], :last_name => data[:professor_lastname]).each do |temp_prof|
				# Operating under the assumption that there are no professors with the same name that have taught the same course.
				if temp_prof.courses_list.include?(course)
					professor = temp_prof
					break
				end
			end

			# Watch for nil objects
			data[:course_id] = course.id if course
			data[:professor_id] = professor.id if professor

			# Create the review
			Review.create({
				:id => data[:id],
				:comment => data[:comment],
				:course_professor_id => data[:course_professor_id],
				:student_id => data[:student_id],
				:semester_id => data[:semester_id],
				:created_at => data[:created_at],
				:updated_at => data[:updated_at],
				:professor_rating => data[:professor_rating],
				:enjoyability => data[:enjoyability],
				:difficulty => data[:difficulty],
				:amount_reading => data[:amount_reading],
				:amount_writing => data[:amount_writing],
				:amount_group => data[:amount_group],
				:amount_homework => data[:amount_homework],
				:only_tests => data[:only_tests],
				:recommend => data[:recommend],
				:ta_name => data[:ta_name],
				:course_id => data[:course_id],
				:professor_id => data[:professor_id]
			})
			log.puts "Finished review #{data[:id]}."

		# If CSV was malformed, log it
		rescue CSV::MalformedCSVError => er
			log.puts er.message
			log.puts "Caused by: #{line}"
		end


	end

	# Close log file
	log.close

	# How long did this take?
	puts "Import Reviews - Total Runtime: #{(Time.now - start_time) / 60} minutes"

else
	puts 'bad input'
end
