require 'csv'

initial_time = Time.now

seasons = {
	:"1" => 'January',
	:"2" => 'Spring',
	:"6" => 'Summer',
	:"8" => 'Fall'
}

ActiveRecord::Base.logger.level = 1

File.open("#{Rails.root.to_s}/data/#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w') do |log|
	Dir.entries("#{Rails.root.to_s}/data/raw/").sort_by(&:to_s).each do |file|
		if file == '.' or file == '..'
			next
		end
		log.puts "Loading #{file}"
		number = file[2..5]
		semester = Semester.find_by(:number => number.to_i)

		unless semester
			log.puts "Creating Semester: #{number}"
			semester = Semester.create({
				:number => number,
				:season => seasons[number[-1].to_sym],
				:year => "20#{number[1..2]}"
			})
		end

		File.open("#{Rails.root.to_s}/data/raw/#{file}").each do |line|
			begin
				data = CSV.parse_line(line)
				if data[0] == 'ClassNumber'
					next
				end
				subdepartment = Subdepartment.find_by(:mnemonic => data[1])

				unless subdepartment
					log.puts "Creating Subdepartment: #{data[1]}"
					subdepartment = Subdepartment.create({
						:mnemonic => data[1]
					})
				end
				course = Course.find_by(:course_number => data[2], :subdepartment_id => subdepartment.id)

				unless course
					log.puts "Creating Course: #{data[1]} #{data[2]}"
					course = Course.create({
						:title => data[9],
						:course_number => data[2].to_i,
						:subdepartment_id => subdepartment.id
					})
				end

				if course.title != data[9]
					log.puts "Mismatch Course Title: #{subdepartment.mnemonic} #{course.course_number}"
					log.puts "#{course.title} vs #{data[9]}"
					course.title = data[9]
					course.save
				end

				# if data[10] and data[10] != ''
				# 	log.puts "Non-blank topic: #{subdepartment.mnemonic} #{course.course_number}"
				# 	log.puts "#{data[10]}"
				# end

				professors = data[6].split(',').map do |professor|
					names = professor.split(' ')
					possible_professors = Professor.where(:first_name => names[0], :last_name => names[-1])
					if possible_professors.count == 1
						possible_professors[0]
					elsif possible_professors.count == 0
						log.puts "Creating Professor #{professor}"
						Professor.create({
							:first_name => names[0],
							:last_name => names[-1]
						})
					else
						log.puts "Duplicate Professor #{professor} for #{semester.year} #{semester.season} #{subdepartment.mnemonic} #{course.course_number}"
						possible_professors.each_index do |index|
							possibility = possible_professors[index]
							log.puts "#{index}: #{possibility.id} - #{possibility.department}"
						end
						# log.puts 'Enter Choice'
						# possible_professors[gets.chomp.to_i]
						possible_professors[0]
					end
				end

				times = data[7].split(' ')
				day_times = times[0].scan(/.{2}/).map do |day|
					if day == 'TB'
						day_time = DayTime.find_by(:day => '')
						if day_time
							day_time
						else
							DayTime.create({
								:day => '',
								:start_time => '',
								:end_time => ''
							})
						end
					else
						start_time = Time.parse(times[1]).strftime("%H:%M")
						end_time = Time.parse(times[3]).strftime("%H:%M")
						day_time = DayTime.find_by(:day => day, :start_time => start_time, :end_time => end_time)
						if day_time
							day_time
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

				location = Location.find_by(:location => data[8])

				unless location
					log.puts "Creating Location #{data[8]}"
					location = Location.create(:location => data[8])
				end

				section = Section.create({
					:sis_class_number => data[0],
					:section_number => data[3],
					:topic => data[1],
					:units => data[5],
					:capacity => data[13],
					:section_type => data[4],
					:course_id => course.id,
					:semester_id => semester.id
				})

				professors.each do |professor|
					SectionProfessor.create({
						:section_id => section.id,
						:professor_id => professor.id
					})
				end

				day_times.each do |day_time|
					ActiveRecord::Base.connection.execute("INSERT INTO day_times_sections (day_time_id, section_id, location_id) VALUES (#{day_time.id}, #{section.id}, #{location.id})")
				end
			rescue CSV::MalformedCSVError => er
				log.puts er.message
				log.puts "#{file} and #{line}"
			end
		end

		log.puts "Finished #{semester.season} #{semester.year} in #{(Time.now - initial_time) / 60} minutes"
	end
	log.puts "Total Runtime: #{(Time.now - initial_time) / 60} minutes"
end