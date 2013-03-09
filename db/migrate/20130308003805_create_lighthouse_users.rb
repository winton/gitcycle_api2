class CreateLighthouseUsers < ActiveRecord::Migration
  def change
    create_table :lighthouse_users do |t|
      t.string  :token
      t.integer :lighthouse_id
      t.integer :user_id

      t.timestamps
    end
  end
end
