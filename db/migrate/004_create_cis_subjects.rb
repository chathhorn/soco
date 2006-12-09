class CreateCisSubjects < ActiveRecord::Migration
  def self.up
    create_table :cis_subjects do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cis_subjects
  end
end
