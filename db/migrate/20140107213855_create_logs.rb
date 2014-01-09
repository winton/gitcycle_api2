class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string   :exit_code
      t.integer  :user_id
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end

    add_index :logs, :exit_code
    add_index :logs, :user_id
    add_index :logs, :started_at
    add_index :logs, :finished_at
    add_index :logs, [ :started_at, :finished_at ]
  end
end
