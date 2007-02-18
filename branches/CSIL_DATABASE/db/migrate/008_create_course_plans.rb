class CreateCoursePlans < ActiveRecord::Migration
  def self.up
    create_table :course_plans do |t|
        t.column :semester_id, :integer, :limit => 11
    end
  end

  def self.down
    drop_table :course_plans
  end
end
