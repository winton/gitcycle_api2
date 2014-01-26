class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.text    :body
      t.string  :name
      t.string  :state
      t.string  :title
      
      t.integer :github_issue_id

      t.string  :lighthouse_namespace
      t.integer :lighthouse_project_id
      t.integer :lighthouse_ticket_id

      t.integer :source_branch_id
      t.integer :repo_id
      t.integer :user_id
      
      t.timestamps

      t.index :name, :unique => true
      t.index :github_issue_id
      t.index :source_branch_id
      t.index :repo_id
      t.index :user_id
    end
  end
end
