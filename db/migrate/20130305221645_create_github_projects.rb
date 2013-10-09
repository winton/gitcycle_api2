class CreateGithubProjects < ActiveRecord::Migration
  def change
    create_table :github_projects do |t|
      t.string  :owner
      t.string  :repo
      
      t.integer :user_id

      t.timestamps

      t.index :user_id
    end
  end
end
