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
File.open("#{Rails.root.to_s}/data/ldap_#{number}").each do |line|
	# Strip (leading whitespace) and chomp (trailing whitespace)
	ldap_professors << line.strip.chomp
end

# Previous choices are stored in ldap_choices, which we want to read in when we continue our analysis (since we can pause)
# Choices are explained later (y = consolidate into one professor)
previous_choices = {}
File.open("#{Rails.root.to_s}/data/ldap_choices_#{number}", "r").each do |line|
	line = line.strip.chomp.split(';')
	# Store as hash, i.e. {:"Lukas Tamm" => 'y'}
	previous_choices[line[0].to_sym] = line[1]
end

# Open LDAP log
ldap_log = File.open("#{Rails.root.to_s}/data/ldap#{number}_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

# Since we are doing another run, wipe the ldap_choices file to store our new set of choices
# Old choices are stored in previous_choices, so we don't actually rewrite anything important
ldap_choices = File.open("#{Rails.root.to_s}/data/ldapchoices#{number}", 'w')

# Ask how many professors to read in - also log how many total
puts "How many? #{ldap_professors.count} total"

# Log that we are starting LDAP lookups
ldap_log.puts "Starting LDAP lookup for professor cases"

# Only go through first X professors, where X is asked previously
ldap_professors[0..gets.chomp.to_i - 1].each do |full_name|
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
		puts "Subdepartments Taught: #{professors.map(&:courses).flatten.map(&:subdepartment).map(&:mnemonic).uniq.join(', ')}"
		# Ask if we should consolidate into one professor, (y)es(n)o(Q)uit
		puts "Should we consolidate? #{full_name} ynQ"
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
			# Arbitrarily choose first professor to assign all sections to
			root = professors[0]
			# For all other duplicate professors
			for professor in professors[1..-1]
				# For each section_professor in each duplicate professor
				professor.section_professors.each do |section_professor|
					# Assign each section_professor with the root professor's id
					section_professor.update(:professor_id => root.id)
				end
				# After we clear out section_professors for this professor, we delete it
				professor.destroy
			end
		# If we chose to quit our analysis
		elsif answer == 'Q'
			break
		end
		# Log each choice for resuming later
		ldap_choices.puts "#{full_name};#{answer}"
	# If, however, LDAP only returned one result, then duplicates are impossible
	elsif response.include?(full_name.split(' ')[0])
		names = full_name.split(' ')
		# Find all duplicate professors to consolidate into one
		professors = Professor.where(:first_name => names[0], :last_name => names[-1])
		# Arbitrarily choose first professor to assign all sections to
		root = professors[0]
		# For all other duplicate professors
		for professor in professors[1..-1]
			# For each section_professor in each duplicate professor
			professor.section_professors.each do |section_professor|
				# Assign each section_professor with the root professor's id
				section_professor.update(:professor_id => root.id)
			end
			# After we clear out section_professors for this professor, we delete it
			professor.destroy
		end
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