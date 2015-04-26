# ORM Familiarity Exercises
# 	https://github.com/thecourseforum/theCourseForum/wiki/ORM-Familiarity-Exercises

ActiveRecord::Base.logger.level = 1


### Introductory ###

# 1. Return how many Subdepartments there are.
Subdepartment.count

# 2. Return the number of courses in a given Subdepartment - say the CS department.
Subdepartment.includes(:courses).find_by(:mnemonic => 'CS').courses.count

# 3. Return an array of professors that correspond to a given course - say ECON 2010.
Course.find_by_mnemonic_number('ECON', 2010).professors.uniq

# 4. Return an array of days i.e. [Mo,We], that a course has been offered, ever - say ECON 2010.
Course.includes(:sections => :day_times).find_by_mnemonic_number('ECON', 2010).sections.flat_map(&:day_times).map(&:day).uniq

# 5. Return an array of Subdepartment mnemonics that a Professor teaches in - say Roquinaldo Ferreira.
Professor.includes(:subdepartments).find_by(:first_name => 'Roquinaldo', :last_name => 'Ferreira').subdepartments.map(&:mnemonic).uniq

# 6. Find the Subdepartment with the most courses.
Subdepartment.includes(:courses).all.map{|x| [x.name, x.courses.count]}.sort_by{|x| x.last}.last


### Intermediate ###

# 1. Compute the average rating for all courses in the COMM subdepartment.
INCOMPLETE
puts Subdepartment.includes(:courses => :reviews).find_by_mnemonic('COMM').courses.map { |cour|
	(cour.reviews.average(:recommend).to_f+cour.reviews.average(:enjoyability).to_f+cour.reviews.average(:professor_rating).to_f)/3
}

# 2. Find the subdepartment with the largest amount of reviews.
Subdepartment.includes(:courses => :reviews).load.map{|x| [x.name, x.courses.flat_map{|y| y.reviews}.count]}.max_by{|x| x[1]} # This takes a while

# 3. Find how many courses that have sections only before 3PM.
INCOMPLETE
puts Course.includes(:sections).load.delete_if { |cour| 
	(not cour.sections.where(:semester_id => 24)[0]) || cour.sections.where(:semester_id => 24).drop_while { |sect| 
			sect.day_times ? Time.parse(sect.day_times.max_by(:start_time).start_time) < Time.parse('15:00') : false 
		}[0] 
	}.count

# 4. Find the Subdepartment with the most total capacity.
Subdepartment.includes(:courses => :sections).where('sections.semester_id = ?', 24).load.map{|x| [x.name, x.courses]}.map{|x| [x[0], x[1].map{|c| c.sections.map(&:capacity).inject(:+)}.inject(:+)]}.max_by{|x| x[1]}

# 5. Find the average units per course in the CS department.
### I can't imagine this being done in one line... the units are stored as a string and a large majority of them are ranges (ex. 1-12)
Subdepartment.includes(:courses => :sections).where(mnemonic: 'CS').load.flat_map(&:courses).flat_map(&:sections).map(&:units).uniq

# 6. Return a course matching by title, i.e. "Program and Data" - notice no "Representation"!
Course.where("title LIKE ?", "%Program and Data%")[0]

# 7. Now make the prior method match both "Program and Data", "data representation".
Course.where("title LIKE ?", "%data%representation%")[0]

# 8. Now make the prior method match "data and program representation".
Course.where("title REGEXP ?", "data and program|representation")[0]


### Advanced ###

# 1. Compare class capacities across the CS and COMM department.
# 2. Compare the professor to capacity ratio between CS and COMM department.
# 3. Compare the ratio of As (A+, A, A-) to total grades (not including drop/withdraw/other) between the CS and COMM department adjusted per course (per section).
# 4. Compute the average ratio of drop (stored in grades) to class capacity.
# 5. Compute the average enjoyability rating for the CS department (and compare with COMM).
# 6. Compute the average difficulty rating for the CS department (and compare with COMM).
# 7. Find the course that has the most swear words in their reviews.
# 8. Find the average number of reviews written by a user (only count those who have written more than 1 review)

### Crazy ###

# 1. Find how many semesters would it take to take every CS course (scheduling!!)
# 2. Compute the total cost of the BIOL department (textbooks based on Amazon price prioritizing new > used) for every course.
# 3. Give the average enjoyability rating of the ECON department, and determine Elzinga's impact on that rating.
# 4. Give the r-value correlation between total cost of a BA CS degree (lookup requirements) in textbooks compared to a BA Biology and capacity.
