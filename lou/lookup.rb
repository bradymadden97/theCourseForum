# Author AlanWei

# IMPORTANT
# Before you run LDAP analysis, you probably want to backup the current state of the database before you perform LDAP lookups, so you can easily reset to that state
# mysql -u root thecourseforum_development < ldap1158.sql

# Squash SQL outputs into the log - can remove to see raw sql queries made
ActiveRecord::Base.logger.level = 1

# Manually assign semester number here
number = 1158

# Read from file professors from orm.rb to read in
ldap_professors = []
File.open("#{Rails.root.to_s}/lou/duplicates/ldap_duplicates_#{number}").each do |line|
	# Strip (leading whitespace) and chomp (trailing whitespace)
	ldap_professors << line.strip.chomp
end

# Previous choices are stored in ldap_choices, which we want to read in when we continue our analysis (since we can pause)
# Choices are explained later (y = consolidate into one professor)
previous_choices = {}
File.open("#{Rails.root.to_s}/lou/choices/ldap_choices_#{number}", "r").each do |line|
	line = line.strip.chomp.split(';')
	# Store as hash, i.e. {:"Lukas Tamm" => 'y'}
	previous_choices[line[0].to_sym] = line[1]
end

# Open LDAP log
ldap_log = File.open("#{Rails.root.to_s}/lou/log/ldap#{number}_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

# Since we are doing another run, wipe the ldap_choices file to store our new set of choices
# Old choices are stored in previous_choices, so we don't actually rewrite anything important
ldap_choices = File.open("#{Rails.root.to_s}/log/choices/ldap_choices_#{number}", 'w')

# Ask how many professors to read in - also log how many total
puts "How many? #{ldap_professors.count} total"
limit = gets.chomp.to_i
puts "Starting from? (0 indexed)"
offset = gets.chomp.to_i


# Log that we are starting LDAP lookups
ldap_log.puts "Starting LDAP lookup for professor cases from #{offset} to #{offset + limit}"

# Only go through range
ldap_professors[offset..limit - 1].each do |full_name|
	# Post the full_name into LDAP lookup
	response = RestClient.post('http://www.virginia.edu/cgi-local/ldapweb/', :whitepages => "#{full_name}")
	# If the response has the word "Person", then there's a table on the page with column headers, which mean multiple matches were found
	if response.include?('Person')
		# For terminal output, manually ask the human to decide
		puts "Analyzing Duplicate Professors #{full_name}"
		names = full_name.split(' ')
		# Find all potential matches for this name in the database
		professors = Professor.where(:first_name => names[0], :last_name => names[-1])
		# Show spread of subdepartments taught by all professors by this name in the database
		# Helps when spread is like EVSC and EVEC (both probably the same professor)
		# puts "Subdepartments Taught: #{professors.map(&:courses).flatten.map(&:subdepartment).map(&:mnemonic).uniq.join(', ')}"
		puts "Subdepartments Taught by #{professors.count} professors"
		professors.each_index do |i|
			print "#{i}) "
			professor = professors[i]
			professor.courses.map(&:subdepartment).uniq.each do |subdepartment|
				print "#{subdepartment.mnemonic}: #{professor.courses_in_subdepartment(subdepartment).count} "
			end
			puts
		end
		# Ask if we should consolidate into one professor, (y)es(n)o(Q)uit
		puts "Should we consolidate? #{full_name} ynQ OR grouping (i.e. 02 3)"
		# If we previously made a choice about this professor, try to fetch it
		previous_choice = previous_choices[full_name.to_sym]
		# If we previously made a choice (not nil)
		if previous_choice
			# Set answer to previous choice
			answer = previous_choice
			# Log that we chose based on prior analysis
			ldap_log.puts "Duplicate with #{full_name} resolved with prior: #{answer}"
		# Otherwise, if we haven't made a choice yet
		else
			# Get user input
			answer = gets.chomp
			# Log that we chose based on now analysis
			ldap_log.puts "Duplicate with #{full_name} resolved with now: #{answer}"
		end
		# Show which we chose
		puts "Choosing #{answer}"
		# If user chose to consolidate professors into one
		if answer == 'y'
			names = full_name.split(' ')
			Professor.consolidate(professors)
		# If we chose to quit our analysis
		elsif answer == 'Q'
			break
		elsif answer == 'n'
		else
			groupings = answer.split(' ')
			groupings.each do |grouping|
				grouping.scan(/./).map
				Professor.consolidate(professors.values_at(*grouping.scan(/./)))
			end
		end
		# Log each choice for resuming later
		ldap_choices.puts "#{full_name};#{answer}"
	# If, however, LDAP only returned one result, then duplicates are impossible
	elsif response.include?(full_name.split(' ')[0])
		names = full_name.split(' ')
		# Find all duplicate professors to consolidate into one
		professors = Professor.where(:first_name => names[0], :last_name => names[-1])
		Professor.consolidate(professors)
		# Might as well assign email_alias while we found a match while we're at it
		# The 3rd table data element has what we want - is hard coded (sorry!)
		email_alias = Nokogiri::HTML(response).css('td')[3].children[0].text.strip
		# Update the root professor with new email_alias
		root.update(:email_alias => "#{email_alias}@virginia.edu")
		# Log that we successfully consolidated this professor
		ldap_log.puts "Consolidated #{root.full_name} #{email_alias}"
	# Only goes here if we are rate limited (too many lookups) or failed to find any matching result
	else
		# Log some data into terminal for us to look at
		puts "Rate limited"
		puts full_name
		puts response
		break
	end
	# Sleep for a tiny second to not overwhelm poor LDAP servers
	sleep(0.001)
end

# Flush buffer into logs
ldap_log.close
ldap_choices.close

# Dump mysql
system("mysqldump -u root -p thecourseforum_development > #{Rails.root.to_s}/lou/backups/post_ldap_#{number}_$(date '+%b_%d_%Y_%H_%M_%S').sql")