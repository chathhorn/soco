

#-------------------------------------------------------------------------------------------------------------#
# WATIR controller
#  test name:  watirSocoConnectFacebook.rb                                           
#                                                                              
#  Simple login test written by Peter M. Gits
# Purpose: to demonstrate the following WATIR functionality:                   
#   * entering text into a user field 
#   * entering text into a password field                                         
#   * clicking a submit button
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

   puts "Step 4: go to the href link: Facebook Friends Sync"

   ie.link(:text, "Facebook Friends Sync").click
   puts "  Action: entered Facebook Friends Sync from the href link."
   puts "## End of test: SocoConnectFacebook"
   puts "Expected Result: "
   puts " - a facebook login page should be shown. 'SocoFacebook' should be high on the list."
  
   puts "Actual Result: Check that the 'SocoFacebook' link appears on the results page "
   if ie.contains_text("SocoFacebook")  
      puts "Test Passed. Found the test string: 'SocoFacebook'. Actual Results match Expected Results."
   else
      puts "Test Failed! Could not find: 'SocoFacebook'" 
   end
   
   puts "  "

# -end of SocoConnectFacebook check test


