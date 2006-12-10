class LoginController < ApplicationController
  def index
    @title = "Login"
    #see login.rhtml
  end
  def validate
    if User.validate(params[:user], params[:pass])
      render_text "sucess"
    else
      render_text "failure"
    end
  end
end
