class CreateCisSemesters < ActiveRecord::Migration
  def self.up
    create_table :cis_semesters do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cis_semesters
  end
end
