#Author Lawrence Hook

# Use rails runner to execute

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

# For 'almost' impenetrable delimiting! --JK didn't do this
require 'digest/sha1'
DELIMITER = Digest::SHA1.hexdigest 'DELIMITER'

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

puts "Dump or Import: (d/i)"
dori = gets.chomp

######## DUMP ########
if dori == 'd'
	# For timing purposes
	start_time = Time.now
	# open log file
	log = File.open("#{Rails.root.to_s}/lou/reviews_dump_log_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')
	# Open ReviewsDump.csv file
	reviews_dump = File.open("#{Rails.root.to_s}/lou/reviews_dump.csv", 'w')

	log.puts "DUMPING REVIEWS"

	# Generate the csv (an all or nothing approach)
	csv_string = CSV.generate do |csv|
		
		# Create the proper header
		header = (Review.column_names - ["course_id", "professor_id"]) + ["mnemonic", "course_number", "first_name", "last_name"]
		csv << header

		# Dump all reviews
		Review.includes(:course, :professor).load.each do |review|
			log.puts "Dumping review #{review.id}"

			# Check if there is assoc. course
			unless review.course
				log.puts "\tError: NO COURSE"
				log.puts "\tSkipping review #{review.id}"
				next
			end

			# Check if there is assoc. prof
			unless review.professor
				log.puts "\tError: NO PROFESSOR"
				log.puts "\tSkipping review #{review.id}"
				next
			end

			# Exclude course_id and professor_id
			column_info = review.attributes.values_at(*(Review.column_names - ["course_id", "professor_id"]))
			# Include mnemonic and course_number
			course_info = review.course.subdepartment.attributes.values_at("mnemonic") + review.course.attributes.values_at("course_number")
			# Include professor first/last name
			prof_info = review.professor.attributes.values_at("first_name", "last_name")

			csv << column_info + course_info + prof_info
		end
	end

	# Write the csv
	reviews_dump.puts csv_string

	# Close log file
	log.puts "All done!"
	log.close

	# How long did this take?
	puts "Dump Reviews - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"
	


######## IMPORT ########
elsif dori == 'i'
	# For timing purposes
	start_time = Time.now
	# open log file
	log = File.open("#{Rails.root.to_s}/data/ReviewsImportLog_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')
	# Open ReviewsDump.csv file
	file = File.read("#{Rails.root.to_s}/data/ReviewsDump.csv")
	# Parse the csv file, 
	csv = CSV.parse(file, :headers => true)
	
	log.puts "IMPORTING REVIEWS"

	# Go through each line in the csv file
	csv.each do |raw|
		# Create the hash (this works because :headers => true)
		row = raw.to_hash

		log.puts "Importing review #{row["id"]}"

		# Try to find course
		course = Course.find_by_mnemonic_number(row["mnemonic"], row["course_number"])
		unless course
			log.puts "\tError: Course not found: #{row["mnemonic"]} #{row["course_number"]}"
			log.puts "\tSkipping.."
			next
		end

		# Declare Professor
		professor = nil
		# Try to find professor
		Professor.where("first_name" => row["first_name"], "last_name" => row["last_name"]).each do |temp_prof|
			# Operating under the assumption that there are no professors with the same name that have taught the same course. 
			# future TODO? build in logic to log the case ^^
			if temp_prof.courses_list.include?(course)
				professor = temp_prof
				break
			end
		end
		unless professor
			log.puts "\tError: Professor not found: #{row["first_name"]} #{row["last_name"]}"
			log.puts "\tSkipping.."
			next
		end

		# Get rid the non-attribute data
		columns = raw.delete_if do |key, value|
			Review.column_names.exclude? key
		end

		# Add the discovered id's!
		columns["course_id"] = course.id
		columns["professor_id"] = professor.id

		# Test to see if parsing works
		# columns.each do |key, value|
		# 	log.puts "\t#{key}: #{value}"
		# end

		# Convert columns (CSV::row -> Hash) and CREATE!
		Review.create(columns.to_hash)

		log.puts "Review created!"

	end

	# Close log file
	log.puts "All done!"
	log.close

	# How long did this take?
	puts "Import Reviews - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"

else
	puts 'bad input'
end
