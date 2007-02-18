class CreateCourseBins < ActiveRecord::Migration
  def self.up
    create_table :course_bins do |t|
        t.column :user_id, :integer, :limit => 11
    end
  end

  def self.down
    drop_table :course_bins
  end
end
