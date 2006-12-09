class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :semesters
  end
end
