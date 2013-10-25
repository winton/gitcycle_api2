class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.text    :body
      t.string  :github_url
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

      t.index [ :name, :source, :user_id ], :unique => true
      t.index :name
      t.index :source
      t.index :repo_id
      t.index :user_id
    end
  end
end
