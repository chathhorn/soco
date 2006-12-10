class LoginController < ApplicationController
  def index
    @title = "Login"
    #see login.rhtml
  end
  def validate
    render_text @params[:user] + " " + @params[:pass]
  end
end
