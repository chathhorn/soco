class CreateCisSemesters < ActiveRecord::Migration
  def self.up
    create_table :cis_semesters do |t|
       t.column :cis_course_id, :integer, :limit => 11
       #instead of type year,
       t.column :year, :date, :limit => 8
       t.column :semester, :string, :limit => 2
    end
  end

  def self.down
    drop_table :cis_semesters
  end
end
