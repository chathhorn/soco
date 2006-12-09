class CreateColleges < ActiveRecord::Migration
  def self.up
    create_table :colleges do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :colleges
  end
end
