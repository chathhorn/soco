class CisCourseAddCourseDependency < ActiveRecord::Migration
  def self.up
    add_column :cis_courses, :course_dependency_id, :integer, :null => false
  end

  def self.down
    remove_column :cis_courses, :course_dependency_id
  end
end
