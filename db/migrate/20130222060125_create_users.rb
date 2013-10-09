class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :gitcycle
      t.string :github
      t.string :gravatar
      t.string :login
      t.string :name

      t.timestamps

      t.index :gitcycle
      t.index :login
    end
  end
end
