ActiveRecord::Base.logger.level = 1

number = 1158

ldap_professors = []
File.open("#{Rails.root.to_s}/data/ldap#{number}").each do |line|
	ldap_professors << line
end

ldap_log = File.open("#{Rails.root.to_s}/data/ldap#{number}_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

puts "How many? #{ldap_professors.count} total"
ldap_log.puts "Starting LDAP lookup for professor cases"
ldap_professors[0..gets.chomp.to_i - 1].each do |full_name|
	full_name = full_name.strip.chomp
	response = RestClient.post('http://www.virginia.edu/cgi-local/ldapweb/', :whitepages => "#{full_name}")
	if response.include?('Person')
		ldap_log.puts "Duplicate with #{full_name}"
		puts "Should we consolidate? #{full_name} y/n"
		answer = gets.chomp
		if answer == 'y'
			names = full_name.split(' ')
			professors = Professor.where(:first_name => names[0], :last_name => names[-1])
			root = professors[0]
			for professor in professors[1..-1]
				professor.section_professors.each do |section_professor|
					section_professor.update(:professor_id => root.id)
				end
				if professor.section_professors.count > 0
					ldap_log.puts "Failed to clear all sections"
				else
					professor.destroy
				end
			end
		end
	elsif response.include?(full_name.split(' ')[0])
		names = full_name.split(' ')
		professors = Professor.where(:first_name => names[0], :last_name => names[-1])
		root = professors[0]
		for professor in professors[1..-1]
			professor.section_professors.each do |section_professor|
				section_professor.update(:professor_id => root.id)
			end
			if professor.section_professors.count > 0
				ldap_log.puts "Failed to clear all sections"
			else
				professor.destroy
			end
		end
		email_alias = Nokogiri::HTML(response).css('td')[3].children[0].text.strip
		root.update(:email_alias => "#{email_alias}@virginia.edu")
		ldap_log.puts "Consolidated #{root.full_name} #{email_alias}"
	else
		puts "Rate limited"
		puts full_name
		puts response
		break
	end
	sleep(0.001)
end

ldap_log.close