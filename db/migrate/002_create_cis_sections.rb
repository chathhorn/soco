class CreateCisSections < ActiveRecord::Migration
  def self.up
    create_table :cis_sections do |t|
       t.column :cis_semester_id, :integer, limit => 11
       t.column :crn, :integer, :limit => 11
       t.column :type, :string, :limit => 15
       t.column :name, :string, :limit => 255
       t.column :startTime, :datetime
       t.column :endTime, :datetime
       #instead of type Set
       t.column :days, :string, :limit => 1
       t.column :room, :string, :limit => 225
       t.column :building, :string, :limit => 225
       t.column :instructor, :string, :limit => 225
    end
  end

  def self.down
    drop_table :cis_sections
  end
end
