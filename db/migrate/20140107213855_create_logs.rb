class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string   :event
      t.string   :body,      :limit => 10_000
      t.string   :backtrace, :limit => 10_000
      t.string   :session_id
      t.integer  :user_id
      t.datetime :ran_at
      t.timestamps
    end

    add_index :logs, [ :ran_at, :session_id ]
    add_index :logs, :user_id
  end
end
