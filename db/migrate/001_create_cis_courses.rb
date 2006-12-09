class CreateCisCourses < ActiveRecord::Migration
  def self.up
    create_table :cis_courses do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cis_courses
  end
end
