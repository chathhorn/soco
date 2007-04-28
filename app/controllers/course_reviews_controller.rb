class CourseReviewsController < ApplicationController

  def list
    @course_id = params[:id]
    
    if @course_id.nil?
      render :text => "You must specify a course id"
      return
    end
    
    @reviews = CisCourse.find(@course_id).course_reviews
  end

  def post
    course_id = params[:id]
    redirect_to :back
    
    if course_id.nil?
      render :text => "You must specify a course id"
      return
    end    

    review = CourseReview.new(params[:course_review])
    review.cis_course = CisCourse.find course_id
    review.user = User.find session[:user]
    
    review.save
  end
end
