Feature: Signing in
	In order to config app values
	As a user
	I want to sign in to do so
	
	Background:
		Given there are the following users:
		| email | password |
		| user@example.com | password |
		
	Scenario: Sign in via a form
		And I am on the sign in page
		When I fill in "Email" with "user@example.com"
		And I fill in "Password" with "password"
		And I press "Sign in"
		Then I should see "Signed in successfully"
		