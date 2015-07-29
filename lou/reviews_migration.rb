#Author Lawrence Hook


# FasterCSV library for ease of parsing, handles commas nested inside quotes too
require 'csv'

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

puts "Dump or Import: (d/i)"
choice = gets.chomp

######## DUMP ########
if choice == 'd'
	# For timing purposes
	start_time = Time.now
	# open log file
	log = File.open("#{Rails.root.to_s}/lou/reviews_dump_log_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')
	# Open ReviewsDump.csv file
	reviews_dump = File.open("#{Rails.root.to_s}/lou/reviews_dump.csv", 'w')

	log.puts "DUMPING REVIEWS"

	bad_reviews = 0

	# Generate the csv (an all or nothing approach)
	csv_string = CSV.generate do |csv|
		
		# Create the proper header
		header = (Review.column_names - ["course_id", "professor_id"]) + ["mnemonic", "course_number", "first_name", "last_name", "professor_email", "student_email"]
		csv << header

		# Dump all reviews
		Review.includes(:course, :professor).load.each do |review|
			# Check if there is assoc. course
			unless review.course
				log.puts "\tError: NO COURSE"
				log.puts "\tSkipping review #{review.id}"
				bad_reviews += 1
				next
			end

			# Check if there is assoc. prof
			unless review.professor
				log.puts "\tError: NO PROFESSOR"
				log.puts "\tSkipping review #{review.id}"
				bad_reviews += 1
				next
			end

			# Exclude course_id and professor_id
			column_info = review.attributes.values_at(*(Review.column_names - ["course_id", "professor_id"]))
			# Include mnemonic and course_number
			course_info = review.course.subdepartment.attributes.values_at("mnemonic") + review.course.attributes.values_at("course_number")
			# Include professor first/last name
			prof_info = review.professor.attributes.values_at("first_name", "last_name", "professor_email")

			csv << column_info + course_info + prof_info + [review.user.email]
		end
	end

	# Write the csv
	reviews_dump.puts csv_string

	# Close log file
	log.puts "All done!"
	log.close

	# How long did this take?
	puts "#{bad_reviews} total bad reviews"
	puts "Dump Reviews - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"

######## IMPORT ########
else
	# For timing purposes
	start_time = Time.now
	# open log file
	log = File.open("#{Rails.root.to_s}/lou/reviews_import_log_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')
	# Open ReviewsDump.csv file
	file = File.read("#{Rails.root.to_s}/lou/reviews_dump.csv")
	# Parse the csv file, 
	csv = CSV.parse(file, :headers => true)
	
	log.puts "IMPORTING REVIEWS"

	failed = 0

	# Go through each line in the csv file
	csv.each do |raw|
		# Create the hash (this works because :headers => true)
		row = raw.to_hash

		# Try to find course
		course = Course.find_by_mnemonic_number("#{row["mnemonic"]} #{row["course_number"]}")
		unless course
			log.puts "Error: Course not found: #{row["mnemonic"]} #{row["course_number"]}"
			failed += 1
			next
		end

		# Declare Professor
		professor = nil
		# Try to find professor
		if row["professor_email"]
			professor = Professor.find_by(:email_alias => row["professor_email"])
		else
			Professor.where(:first_name => row["first_name"], :last_name => row["last_name"]).each do |candidate|
			# Operating under the assumption that there are no professors with the same name that have taught the same course. 
			# future TODO? build in logic to log the case ^^
				if !professor and candidate.courses.include?(course)
					professor = candidate
				elsif candidate.courses.include?(course)
					puts "Multiple Professors Same Course #{course.mnemonic_number} #{row["first_name"]} #{row["last_name"]}"
				end
			end
		end

		unless professor
			log.puts "Error: Professor not found: #{row["first_name"]} #{row["last_name"]}"
			failed += 1
			next
		end

		# Get rid the non-attribute data
		columns = raw.delete_if do |key, value|
			Review.column_names.exclude? key
		end

		user = User.find_by(:email => row["student_email"])

		unless user
			log.puts "Error: No User Found #{row["student_email"]}"
			failed += 1
			next
		end

		# Add the discovered id's!
		columns[:course_id] = course.id
		columns[:professor_id] = professor.id
		columns[:student_id] = user.id

		# Convert columns (CSV::row -> Hash) and CREATE!
		Review.create(columns.to_hash)
	end

	# Close log file
	log.puts "All done!"
	log.close

	# How long did this take?
	puts "Import Reviews - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"
	puts "#{failed} bad reviews"
end
