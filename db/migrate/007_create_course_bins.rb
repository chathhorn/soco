class CreateCourseBins < ActiveRecord::Migration
  def self.up
    create_table :course_bins do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :course_bins
  end
end
