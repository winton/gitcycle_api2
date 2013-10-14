class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.text    :body
      t.string  :issue_url
      t.string  :labels
      t.string  :lighthouse_url
      t.string  :milestone
      t.integer :milestone_id
      t.string  :name
      t.string  :source
      t.string  :title

      t.integer :repo_id
      t.integer :user_id
      
      t.timestamps

      t.index :name,   :unique => true
      t.index :source, :unique => true
      t.index :repo_id
      t.index :user_id
    end
  end
end
