class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.column :username, :string, :limit => 255
        t.column :password, :binary, :limit => 40
        t.column :first_name, :string, :limit => 255
        t.column :last_name, :string, :limit => 255
        t.column :email, :string, :limit => 255
        t.column :grad_year, :date, :limit => 8
        t.column :grad_sem, :string, :limit => 2
        t.column :birthday, :date, :limit => 8
    end
  end

  def self.down
    drop_table :users
  end
end
