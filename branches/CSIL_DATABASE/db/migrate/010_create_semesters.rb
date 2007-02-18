class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
        t.column :user_id, :integer, :limit => 11
        t.column :year, :date, :limit => 8
        t.column :semester, :string, :limit => 2
    end
  end

  def self.down
    drop_table :semesters
  end
end
