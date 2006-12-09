class CreateCisSections < ActiveRecord::Migration
  def self.up
    create_table :cis_sections do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cis_sections
  end
end
