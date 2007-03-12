class CreateColleges < ActiveRecord::Migration
  def self.up
    create_table "colleges", :force => true do |t|
      t.column "code", :string, :limit => 2,  :default => "", :null => false
      t.column "name", :string, :limit => 45, :default => "", :null => false
    end
  end

  def self.down
    drop_table :colleges
  end
end
