require 'net/smtp'

class FriendMailer < ActionMailer::Base

  def see_my_schedule(my_name, my_email, friend_name, friend_email, classes_shared)
    @subject    = "Take a look at #{my_name}'s classes for the following semester"
    @body       = " #{friend_name}, would you like to join #{my_name} in any of these classes? #{classes_shared}\n\n Use your email address (#{friend_email}) to log in if you are not already registered with soco. http://localhost:3000/login"
    @recipients = friend_email
    @from       = my_email
    @sent_on    = Time.now
    @headers    = {}
  end
end
