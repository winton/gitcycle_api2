class CreateLighthouseProjects < ActiveRecord::Migration
  def change
    create_table :lighthouse_projects do |t|
      t.string  :namespace
      t.integer :number

      t.timestamps
    end
  end
end
