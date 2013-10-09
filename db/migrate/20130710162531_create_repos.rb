class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string  :name
      t.string  :login

      t.integer :owner_id
      t.integer :user_id
      
      t.timestamps

      t.index :owner_id
      t.index :user_id
    end
  end
end
