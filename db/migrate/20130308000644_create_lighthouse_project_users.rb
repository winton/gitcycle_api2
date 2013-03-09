class CreateLighthouseProjectUsers < ActiveRecord::Migration
  def change
    create_table :lighthouse_project_users do |t|
      t.integer :lighthouse_project_id
      t.integer :lighthouse_user_id

      t.timestamps
    end
  end
end
