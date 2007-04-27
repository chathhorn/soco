class Messages < ActiveRecord::Base

  validates_presence_of :username, :course, :timestamp, :time, :subject, :message


end


  #Given Surname
  def to_s
#    return username + " " + message
#    return username + " " + time + " " + subject + "<b>... </b>" + message + "\n\r<br>"
 return "<div class='content'><div class='topic'><div class='info'><span>" + time + "</span>&nbsp; Author: " + username + "</div><h2><a rel='bookmark' title=''>" + subject + "</a></h2></div><div class='text'><p>" + message + "</p><div class='spacer'><br style='clear: both;'></div></div><div class='comment'><a href=\"javascript:document.forms['f'].elements[1].focus();document.forms['f'].elements[0].focus();\">reply</a></div></div>"
  end
  
  

