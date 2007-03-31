

#-------------------------------------------------------------------------------------------------------------#
# WATIR controller
#  test name:  watirSocoCreateUserDeleteUserLogin.rb                                           
#                                                                              
#  Simple createUser delete same user and try to login with same user test written by Peter M. Gits
# Purpose: to demonstrate the following WATIR functionality:   
#   * click on createUser                
#   * entering text into a user field 
#   * entering text into a password field                                         
#   * clicking a submit button
#   * delete user
#   * login again same user
#   * checking to see if a page contains text.                                                                  
#
#------------------------------------------------------------------------------------------------------------#

   require 'watir'   # the watir controller

   # set a variable
   test_site = 'http://localhost:3000/login'
  
   # open the IE browser
   ie = Watir::IE.new

   # print some comments
   puts "## Beginning of test: login to soco"
   puts "  "
  
   puts "Step 1: go to the test site: " + test_site
   ie.goto(test_site)
   puts "  Action: entered " + test_site + " in the address bar."

   puts "Step 2: create a new user"
   ie.link(:text, "Create an Account").click

   puts "Step 3: enter 'pgits' in the username field"
   ie.text_field(:id, "user_username").set("pgits100")    # user is the name of the user field
   puts "  Action: entered pgits100 in the user field"
   ie.text_field(:id, "user_password").set("pgits100")      # pass is the name of the password field
   puts "  Action: entered pgits100 in the password field"


   ie.text_field(:id, "user_first_name").set("Peter100")      # pass is the name of the password field
   puts "  Action: entered Peter100 in the user first name field"


   ie.text_field(:id, "user_last_name").set("Gits100")      # pass is the name of the password field
   puts "  Action: entered Gits100 in the last name field"

   ie.text_field(:id, "user_email").set("pgits100@gmail.com")      # pass is the name of the password field
   puts "  Action: entered Gits100 in the email field"

   puts "Step 3: click the 'Create' button"
   ie.button(:name, "commit").click   # "commit" is the name of the submit button
   puts "  Action: clicked the Create button."

   ie.link(:text, "Delete Your Account").click
   puts "Step 4: click the 'Delete Your Account' button"

   puts "Step 5: go to the test site: " + test_site
   ie.goto(test_site)
   puts "  Action: entered " + test_site + " in the address bar."
   puts "Step 6: enter 'pgits100' in the username field"
   ie.text_field(:name, "user").set("pgits100")       # user is the name of the user field
   puts "  Action: entered pgits in the user field"
   ie.text_field(:name, "pass").set("pgits100")      # pass is the name of the password field
   puts "  Action: entered pgits in the password field"

   puts "Step 7: click the 'Login' button"
   ie.button(:name, "commit").click   # "commit" is the name of the submit button
   puts "  Action: clicked the Login button."

   puts "Expected Result: "
   puts " - a pgits profile page with results should be shown. 'Peter Gits' should be high on the list."
  
   puts "Actual Result: Check that the 'Peter100 Gits100' link appears on the results page "
   if ie.contains_text("Peter100 Gits100")  
      puts "Test Failed! Found : 'Peter100 Gits100'" 
   else
      puts "Test Passed. Didn't Find the test string: 'Peter Gits'. Actual Results don't match Expected Results."
   end
   
   puts "  "
   puts "## End of test: SocoCreateUserDeleteUserLogin"

# -end of SocoCreateUserDeleteUserLogin check test


