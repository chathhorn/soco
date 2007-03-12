class CreateMajors < ActiveRecord::Migration
  def self.up
    create_table "majors", :force => true do |t|
      t.column "name",       :string,                :default => "", :null => false
      t.column "college_id", :integer, :limit => 10,                 :null => false
    end
  end

  def self.down
    drop_table :majors
  end
end
