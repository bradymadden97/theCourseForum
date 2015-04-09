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

# part1 - DUMP reviews
def dump_reviews

	# For timing purposes
	total_time = Time.now

	# Open ReviewsDump.csv file
	reviews_dump = File.open("#{Rails.root.to_s}/data/ReviewsDump.csv", 'w')

	# Header for columns
	reviews_dump.puts "id, comment, course_professor_id, student_id, " \
			"semester_id, created_at, updated_at, professor_rating," \
			"enjoyability, difficulty, amount_reading, amount_writing, " \
			"amount_group, amount_homework, only_tests, recommend, ta_name, " \
			"course_mnemonic, course_number, professor_firstname, professor_lastname"

	# Get all reviews
	Review.all.each do |review|
		# professor assoc. w/ review
		theProf = Professor.find_by_id(review.professor_id)
		
		# course assoc. w/ review
		theCourse = Course.find_by_id(review.course_id)
		
		# Watch for nil course
		if theCourse
			# subdepartment assoc. w/ course
			theSubdep = Subdepartment.find_by_id(theCourse.subdepartment_id)
		end

		# All the info needed that is assessible directly from review
		reviews_info = [review.id, review.comment, review.course_professor_id, review.student_id,
				review.semester_id, review.created_at, review.updated_at, review.professor_rating,
				review.enjoyability, review.difficulty, review.amount_reading, review.amount_writing,
				review.amount_group, review.amount_homework, review.only_tests, review.recommend, review.ta_name]

		# Add the "indirect" data (i.e. course_mnemonic, course_number, professor_firstname, professor_lastname)
		# Avoid the errors of calling methods on nil objects -- in the case that a review does not have an associated professor or course
		if theSubdep
			reviews_info << theSubdep.mnemonic
		else
			reviews_info << nil
		end

		if theCourse
			reviews_info << theCourse.course_number
		else
			reviews_info << nil
		end

		if theProf
			reviews_info << theProf.first_name
			reviews_info << theProf.last_name
		else
			reviews_info << nil
			reviews_info << nil
		end

		# At last, write the info of each review to the ReviewsDump.csv file
		reviews_dump.puts reviews_info.to_csv(:quote_char => "'")

	end
# How long did this take?
puts "Dump Reviews - Total Runtime: #{(Time.now - total_time) / 60} minutes"

end

# part2 - IMPORT reviews
def import_reviews

	# puts "Warning: This method drops all current reviews in the database. Continue? (y/n)"
	# warning = gets.chomp
	# if warning == 'n'
	# 	abort("Aborting...")
	# else
	# 	if warning == 'y'
	# 		puts 'Proceeding...'
	# 	else
	# 		puts 'Bad input: aborting...'
	# 	end
	# end

	# Review.delete_all

	# For timing purposes
	total_time = Time.now

	# Open ReviewsDump.csv file
	reviews_dump = File.open("#{Rails.root.to_s}/data/ReviewsDump.csv", 'r')

	reviews_dump.each do |line|
		# Parse line into array, raw
		raw = CSV.parse_line(line)

		# Skip the header line
		if raw[0] == 'id'
			next
		else
			data = {
				"id" => raw[0],
				"comment" => raw[1],
				"course_professor_id" => raw[2],
				"student_id" => raw[3],
				"semester_id" => raw[4],
				# "created_at" => raw[5],
				# "updated_at" => raw[6],
				"professor_rating" => raw[7],
				"enjoyability" => raw[8],
				"difficulty" => raw[9],
				"amount_reading" => raw[10],
				"amount_writing" => raw[11],
				"amount_group" => raw[12],
				"amount_homework" => raw[13],
				"only_tests" => raw[14],
				"recommend" => raw[15],
				"ta_name" => raw[16],
				"course_mnemonic" => raw[17],
				"course_number" => raw[18],
				"professor_firstname" => raw[19],
				"professor_lastname" => raw[20]
			}

			# Try to find course
			course = Course.find_by_mnemonic_number(data["course_mnemonic"], data["course_number"])

			# Declare Professor
			professor = nil

			# Try to find professor
			Professor.where(:first_name => data["professor_firstname"], :last_name => data["professor_lastname"]).each do |temp_prof|
				# Operating under the assumption that there are no professors with the same name that have taught the same course.
				# Hopefully this will always be true
				if temp_prof.courses_list.include?(course)
					professor = temp_prof
					break
				end
			end

			# Watch for nil objects
			if course
				data["course_id"] = course.id
			end
			if professor
				data["professor_id"] = professor.id
			end

			# Create the review
			Review.create({
				:id => data["id"],
				:comment => data["comment"],
				:course_professor_id => data["course_professor_id"],
				:student_id => data["student_id"],
				:semester_id => data["semester_id"],
				:created_at => data["created_at"],
				:updated_at => data["updated_at"],
				:professor_rating => data["professor_rating"],
				:enjoyability => data["enjoyability"],
				:difficulty => data["difficulty"],
				:amount_reading => data["amount_reading"],
				:amount_writing => data["amount_writing"],
				:amount_group => data["amount_group"],
				:amount_homework => data["amount_homework"],
				:only_tests => data["only_tests"],
				:recommend => data["recommend"],
				:ta_name => data["ta_name"],
				:course_id => data["course_id"],
				:professor_id => data["professor_id"]
			})

			puts '...'
		end
	end

# How long did this take?
puts "Import Reviews - Total Runtime: #{(Time.now - total_time) / 60} minutes"

end


puts "Dump or Import: (d/i)"
dori = gets.chomp

if dori == 'd'
	dump_reviews
elsif dori == 'i'
	import_reviews
else
	puts 'bad input'
end