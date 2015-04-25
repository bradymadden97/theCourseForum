ActiveRecord::Base.logger.level = 1

puts "Dump or Import? (d/i)"

choice = gets.chomp

if choice == 'd'
	file = File.open("#{Rails.root.to_s}/lou/professor_emails", 'w')

	Professor.where.not(:email_alias => nil).each do |professor|
		file.puts "#{[professor.first_name, professor.last_name, professor.email_alias].join(',')}"
	end

	file.close
else
	total = 0
	bad = 0
	File.open("#{Rails.root.to_s}/lou/professor_emails").each do |line|
		first_name, last_name, email_alias = line.split(',')
		professor = Professor.find_by(:email_alias => email_alias)

		total += 1

		if professor
			if professor.first_name != first_name
				puts "First Name: #{professor.first_name} vs #{first_name}"
			elsif professor.last_name != last_name
				puts "Last Name: #{professor.last_name} vs #{last_name}"
			end
		else
			professors = Professor.where(:first_name => first_name, :last_name => last_name)
			if professors.count == 1
				professors.first.update(:email_alias => "#{email_alias}@virginia.edu")
			elsif professors.count == 0
				puts "No match for #{[first_name, last_name].join(' ')}"
				bad += 1
			else
				puts "Multiple Match for #{first_name} #{last_name}"
				bad += 1
			end
		end
	end
	puts "#{bad.to_f / total * 100}% bad (#{bad}/#{total})"
end