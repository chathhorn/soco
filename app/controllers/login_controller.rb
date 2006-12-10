class LoginController < ApplicationController
  def index
    @title = "Login"
    #see login.rhtml
  end
  def validate
    if User.validate_user(params[:user], params[:pass]) != nil
      render_text "success"
    else
      render_text "failure"
    end
  end
end
