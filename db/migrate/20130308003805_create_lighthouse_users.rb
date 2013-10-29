class CreateLighthouseUsers < ActiveRecord::Migration
  def change
    create_table :lighthouse_users do |t|
      t.string  :token
      t.integer :user_id

      t.timestamps

      t.index :token
      t.index :user_id
    end
  end
end
