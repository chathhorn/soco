

#-------------------------------------------------------------------------------------------------------------#
# WATIR controller
#  test name:  watirSocoLoginLogoutLogin.rb                                           
#                                                                              
#  Simple login logout login test written by Peter M. Gits
# Purpose: to demonstrate the following WATIR functionality:                   
#   * entering text into a user field 
#   * entering text into a password field                                         
#   * clicking a submit button
#   * logout
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

   puts "Step 2: enter 'pgits' in the username field"
   ie.text_field(:name, "user").set("pgits")       # user is the name of the user field
   puts "  Action: entered pgits in the user field"
   ie.text_field(:name, "pass").set("pgits")      # pass is the name of the password field
   puts "  Action: entered pgits in the password field"

   puts "Step 3: click the 'Login' button"
   ie.button(:name, "commit").click   # "commit" is the name of the submit button
   puts "  Action: clicked the Login button."

   ie.link(:text, "Logout").click
   puts "Step 4: click the 'Logout' button"

   puts "repeating steps 2 & 3"
   puts "Step 2: enter 'pgits' in the username field"
   ie.text_field(:name, "user").set("pgits")       # user is the name of the user field
   puts "  Action: entered pgits in the user field"
   ie.text_field(:name, "pass").set("pgits")      # pass is the name of the password field
   puts "  Action: entered pgits in the password field"

   puts "Step 3: click the 'Login' button"
   ie.button(:name, "commit").click   # "commit" is the name of the submit button
   puts "  Action: clicked the Login button."

   puts "Expected Result: "
   puts " - a pgits profile page with results should be shown. 'Peter Gits' should be high on the list."
  
   puts "Actual Result: Check that the 'Peter Gits' link appears on the results page "
   if ie.contains_text("Peter Gits")  
      puts "Test Passed. Found the test string: 'Peter Gits'. Actual Results match Expected Results."
   else
      puts "Test Failed! Could not find: 'Peter Gits'" 
   end
   
   puts "  "
   puts "## End of test: SocoUserLoginLogoutLogin"

  

# -end of SocoUserLoginLogoutLogin check test


