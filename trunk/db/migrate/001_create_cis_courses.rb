class CreateCisCourses < ActiveRecord::Migration
  def self.up
    create_table :cis_courses do |t|
       t.column :cis_subject, :integer, :limit => 11
       t.column :number, :integer, :limit => 3, :unsigned => true
       t.column :title, :string, :limit => 255
    end
  end

  def self.down
    drop_table :cis_courses
  end
end
