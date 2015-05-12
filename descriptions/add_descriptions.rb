# Author: Lawrence Hook

# GOAL - Add course descriptions to courses
# 	This information is provided with the lou's data.
# 	Go through sections and identify their respective course with MNEMONIC + NUMBER
# 	and add the description, if not yet done so.

# Squash SQL outputs into the log - can remove to see raw sql queries made
require 'csv'

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

# For timing purposes
start_time = Time.now
# open log file
log = File.open("#{Rails.root.to_s}/descriptions/add_descriptions_log_#{start_time.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

# Go through every file inside descriptions/lous to load into database
# Sorted so earlier semesters are done first
Dir.entries("#{Rails.root.to_s}/descriptions/lous/").sort_by(&:to_s).each do |file|
	# Skip these directory contents
	if file[0] == '.'
		next
	end

	# Initialize timestamp per csv
	csv_time = Time.now

	log.puts "Loading from #{file}"

	# Convert filename to actual file
	file = File.open("#{Rails.root.to_s}/descriptions/lous/#{file}")

 	# Parse the csv file
	csv = CSV.parse(file, :headers => true)

	failed = 0

	puts csv

	# Go through each line in the csv file
	csv.each do |raw|
		# Create the hash (this works because :headers => true)
		row = raw.to_hash

		# Try to find course
		course = Course.find_by_mnemonic_number("#{row["Mnemonic"]}","#{row["Number"]}")
		unless course
			log.puts "Error: Course not found: #{row["Mnemonic"]} #{row["Number"]}"
			failed += 1
			next
		end

		unless course.description
			course.description = row["Description"]
			course.save
		end

	end

	# Log file runtime
	log.puts "Finished #{File.basename(file.path)} in #{((Time.now - csv_time) / 60).round(2)} minutes"
	puts "Finished #{File.basename(file.path)} in #{((Time.now - csv_time) / 60).round(2)} minutes"

end


# How long did this take?
log.puts "Adding Descriptions - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"
puts "Adding Descriptions - Total Runtime: #{((Time.now - start_time) / 60).round(2)} minutes"