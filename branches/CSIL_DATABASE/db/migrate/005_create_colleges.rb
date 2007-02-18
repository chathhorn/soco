class CreateColleges < ActiveRecord::Migration
  def self.up
    create_table :colleges do |t|
        t.column :user_id, :integer, :limit => 11
        t.column :code, :string, :limit => 2
    end
  end

  def self.down
    drop_table :colleges
  end
end
