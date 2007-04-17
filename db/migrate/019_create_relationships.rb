class CreateRelationship < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.column "user_id", :integer, :null => false
      t.column "friend_id",  :integer, :null => false
    end
  end

  def self.down
    drop_table :relationships
  end
end
