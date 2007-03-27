#-------------------------------------------------------------------------------------------------------------#
# WATIR controller
#
# Simple script to check whether application controls duplicated usernames
# Self-descriptive
#------------------------------------------------------------------------------------------------------------#

 

require 'watir' # the watir controller

# set a variable
test_site = 'http://localhost:3000/login'

 

# open the IE browser
ie = Watir::IE.new

 

puts "Step 1: go to the test site: " + test_site
ie.goto(test_site)
puts " Action: entered " + test_site + " in the address bar."

 

puts "Trying to register a new username using the name of an existing username"
puts "Also trying to overflow the application using escape chars"
ie.link(:text, "Create an Account").click

 

puts "Filling INPUT fields..."
ie.text_field(:id, "user_username").set("apradom2")
ie.text_field(:id, "user_password").set("helloworld")
ie.text_field(:id, "user_password_confirmation").set("helloworld")
ie.text_field(:id, "user_first_name").set("Over'|´\"flow")
ie.text_field(:id, "user_last_name").set("                    ")
ie.text_field(:id, "user_email").set("duplicated@user.com")
puts "Filling Comboboxes... "

ie.select_list( :name , "user[college_id]").select("Business")
ie.select_list( :name , "user[major_id]").select("Nondegree")


ie.button(:name, "commit").click 
# "commit" is the name of the submit button
puts " Action: clicked the Create button."


puts "> Expected Result: "
puts "> Registration fails because username already exists"

 

if ie.contains_text("Username has already been taken")
puts "Test Passed!"
else
puts "Test Failed! This username already existed and should not be allowed"
end

puts "## End of test: Duplicated username"
