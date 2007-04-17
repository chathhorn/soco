class CreateSharedCourses < ActiveRecord::Migration
  def self.up
    create_table :shared_courses do |t|
      t.column "cis_course_id", :integer, :null => false
      t.column "connection_id",  :integer, :null => false
    end
  end

  def self.down
    drop_table :shared_courses
  end
end
