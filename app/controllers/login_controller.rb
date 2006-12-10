class LoginController < ApplicationController
  def index
  end
  def validate
    @user = User.authenticate(params[:user], params[:pass])
    if @user != nil
      @session[:user] = @user.id
      redirect_to(:controller => 'long_term')
    else
      render :action => 'index'
      flash[:error] = "Invalid user name or password."
    end
  end
  
  def auto_complete_for_course_number
    render_text params[:course][:number]
#    @auto_courses = subject_numbers_like params[:course][:number]
#    render :partial => 'auto_complete_course'
  end
  
end
