class CreateCisSections < ActiveRecord::Migration
  def self.up
    create_table :cis_sections do |t|
      # t.column :name, :string
#      t.column :cis_semester_id, :integer
#      t.column :crn, :integer
#      t.column :type, :varchar, :limit => 15
#      t.column :name, :varchar, :limit => 255
#      t.column :startTime, :datetime
#      t.column :endTime, :datetime
    end
  end

  def self.down
    drop_table :cis_sections
  end
end
