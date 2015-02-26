connection = ActiveRecord::Base.connection

def data(table)
	return [ActiveRecord::Base.connection.execute("DESCRIBE #{table}").to_a.map(&:first), ActiveRecord::Base.connection.execute("SELECT * FROM #{table}").to_a]
end

def readIn(arr, tablename)
	column = "(#{arr[0].join(', ')})"
	arr[1].each do |element|
		element.map! do |a|
			case a.class
			when String
				"'#{a.gsub("'", "''")}'"
			when Time
				"'#{a.to_s[0..-5]}'"
			when NilClass
				"NULL"
			else
				a
			end
		end
		values = "(#{element.join(', ')})"
		sql = "INSERT INTO #{tablename} #{column} VALUES #{values}"
	end
end

book_requirements = data('book_requirements')
books = data('books')
courses = data('courses')
courses_users = data('courses_users')
day_times = data('day_times')
false_day_times_sections = data('day_times_sections')
departments = data('departments')
departments_subdepartments = data('departments_subdepartments')
grades = data('grades')
locations = data('locations')
majors = data('majors')
professor_salary = data('professor_salary')
professors = data('professors')
reviews = data('reviews')
schools = data('schools')
section_professors = data('section_professors')
sections = data('sections')
sections_users = data('sections_users')
semesters = data('semesters')
settings = data('settings')
student_majors = data('student_majors')
students = data('students')
subdepartments = data('subdepartments')
users = data('users')
votes = data('votes')

puts 'loading table'
aa = gets

puts 'loading data'

day_times_locations = []
day_times_sections = []
locations_sections = []
false_day_times_sections[1].each do |element|
	day_times_locations << [element[0], element[2]]
	day_times_sections << [element[0], element[1]]
	locations_sections << [element[2], element[1]]
end
day_times_locations.uniq!
day_times_sections.uniq!
locations_sections.uniq!

day_times_locations.each do |data|
	sql = "INSERT INTO day_times_locations (day_time_id, location_id) VALUES (#{data[0]}, #{data[1]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with day_times_locations'

day_times_sections.each do |data|
	sql = "INSERT INTO day_times_sections (day_time_id, section_id) VALUES (#{data[0]}, #{data[1]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with day_times_sections'

locations_sections.each do |data|
	sql = "INSERT INTO locations_sections (location_id, section_id) VALUES (#{data[0]}, #{data[1]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with locations_sections'

courses[1].each do |data|
	if data[5].class == NilClass
		data[5] = "NULL    "
	else
		data[5] = "'#{data[5].to_s[0..-5]}'"
	end
	data[1] = data[1].gsub("'", "''")
	sql = "INSERT INTO courses (id, title, number, subdepartment_id, created_at, updated_at) VALUES (#{data[0]}, '#{data[1]}', #{data[2]}, #{data[3]}, '#{data[4].to_s[0..-5]}', #{data[5]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with courses'

book_requirements[1].count.times do |i|
	data = book_requirements[1][i]
	sql = "INSERT INTO requirements (id, book_id, section_id, status) VALUES (#{i + 1}, #{data[0]}, #{data[1]}, '#{data[2]}')"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with requirements'

readIn(books, 'books')
puts 'done with books'

readIn(courses_users, 'courses_users')
puts 'done with courses_users'

readIn(day_times, 'day_times')
puts 'done with day_times'

readIn(departments, 'departments')
puts 'done with departments'

readIn(departments_subdepartments, 'departments_subdepartments')
puts 'done with departments_subdepartments'

grades[1].each do |data|
	data[19] = data[19].to_s[0..-5]
	data[19] = "'#{data[19]}'"
	if data[20].class == NilClass
		data[20] = "NULL    "
	else
		data[20] = "'#{data[20].to_s[0..-5]}'"
	end
	sql = "INSERT INTO grades (id, section_id, gpa, count_a, count_aminus, count_bplus, count_b, count_bminus, count_cplus, count_c, count_cminus, count_dplus, count_d, count_dminus, count_f, count_drop, count_withdraw, count_other, created_at, updated_at, count_aplus, total) VALUES (#{data[0]}, #{data[1]}, #{data[3]}, #{data[4]}, #{data[5]}, #{data[6]}, #{data[7]}, #{data[8]}, #{data[9]}, #{data[10]}, #{data[11]}, #{data[12]}, #{data[13]}, #{data[14]}, #{data[15]}, #{data[16]}, #{data[17]}, #{data[18]}, #{data[19]}, #{data[20]}, #{data[21]}, #{data[22]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with grades'

locations[1].each do |data|
	data[2] = data[2].to_s[0..-5]
	data[2] = "'#{data[2]}'"
	if data[3].class == NilClass
		data[3] = "NULL    "
	else
		data[3] = "'#{data[3].to_s[0..-5]}'"
	end
	sql = "INSERT INTO locations (id, name, created_at, updated_at) VALUES (#{data[0]}, '#{data[1]}', #{data[2]}, #{data[3]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with locations'

readIn(majors, 'majors')
puts' done with majors'

column = "(#{professors[0][0..-2].join(', ')})"
professors[1].each do |data|
	data.map! do |a|
		if a.class == String
			"'#{a.gsub("'", "''")}'"
		elsif a.class == Time
			"'#{a.to_s[0..-5]}'"
		elsif a.class == NilClass
			"NULL"
		else
			a
		end
	end
	values = "(#{data[0..-2].join(', ')})"
	sql = "INSERT INTO professors #{column} VALUES #{values}"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with professors'

professor_salary[1].each do |data|
	data[2] = data[2].gsub("'", "''")
	data[5] = data[5].gsub("'", "''")
	sql = "UPDATE professors SET staff_type='#{data[1]}', assignment_organization='#{data[2]}', annual_salary='#{data[3]}', normal_hours='#{data[4]}', working_title='#{data[5]}' WHERE id=#{data[0]}"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with salaries'

reviews[1].each do |data|
	data.map! do |a|
		if a.class == String
			"'#{a.gsub("'", "''")}'"
		elsif a.class == Time
			"'#{a.to_s[0..-5]}'"
		elsif a.class == NilClass
			"NULL"
		else
			a
		end
	end
	sql = "INSERT INTO reviews (id, comment, student_id, semester_id, created_at, updated_at, professor_rating, enjoyability, difficulty, amount_reading, amount_writing, amount_group, amount_homework, only_tests, recommend, ta_name, course_id, professor_id) VALUES (#{data[0]}, #{data[1]}, #{data[3]}, #{data[4]}, #{data[5]}, #{data[6]}, #{data[7]}, #{data[8]}, #{data[9]}, #{data[10]}, #{data[11]}, #{data[12]}, #{data[13]}, #{data[14]}, #{data[15]}, #{data[16]}, #{data[17]}, #{data[18]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with reviews'

readIn(schools, 'schools')
puts 'done with schools'

section_professors[1].each do |data|
	sql = "INSERT INTO professors_sections (professor_id, section_id) VALUES (#{data[2]}, #{data[1]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with section_professors'

readIn(sections, 'sections')
puts 'done with sections'

readIn(sections_users, 'sections_users')
puts 'done with sections_users'

readIn(semesters, 'semesters')
puts 'done with semesters'

readIn(settings, 'settings')
puts 'done with settings'

student_majors[1].each do |data|
	sql = "INSERT INTO majors_students (major_id, student_id) VALUES (#{data[2]}, #{data[1]})"
	ActiveRecord::Base.connection.execute(sql)
end
puts 'done with student_majors'

readIn(students, 'students')
puts 'done with students'

readIn(subdepartments, 'subdepartments')
puts 'done with subdepartments'
readIn(users, 'users')
puts 'done with users'
readIn(votes, 'votes')
puts 'done!!'