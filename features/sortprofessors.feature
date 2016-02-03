@javascript
Feature: Sort professors
	As a main feature on theCourseForum
	I want to be able to sort professors by stats

	Background:
		Given a user is logged in				
		And courses exist
		And I click the link 'Browse All'
		And I click the link 'Computer Science'
		And I wait 5 seconds
		And I press the button 'All'
		And I wait 5 seconds		
		And I click on 'CS 2150'

	# Scenario: should be able to navigate to the about page
		# When I click the link 'ABOUT'
		# Then I should see 'theCourseForum: What is it good for?'

