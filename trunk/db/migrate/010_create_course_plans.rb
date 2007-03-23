class CreateCoursePlans < ActiveRecord::Migration
  def self.up
    create_table "course_plans", :force => true do |t|
      t.column "semester_id", :integer, :null => false
    end
  end

  def self.down
    drop_table :course_plans
  end
end
