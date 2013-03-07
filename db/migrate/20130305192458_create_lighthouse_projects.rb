class CreateLighthouseProjects < ActiveRecord::Migration
  def change
    create_table :lighthouse_projects do |t|
      t.string  :namespace
      t.integer :number
      t.string  :token
      t.integer :user_id

      t.timestamps
    end
  end
end
