class CreateMajors < ActiveRecord::Migration
  def self.up
    create_table :majors do |t|
        t.column :name, :string, :limit => 255
        t.column :user_id, :integer, :limit => 11
    end
  end

  def self.down
    drop_table :majors
  end
end
