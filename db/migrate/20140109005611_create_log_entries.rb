class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.string  :event
      t.string  :body,      :limit => 10_000
      t.string  :backtrace, :limit => 10_000
      t.integer :ran_at,    :limit => 8
      t.integer :log_id
      t.integer :user_id
      t.timestamps
    end

    add_index :log_entries, :event
    add_index :log_entries, :log_id
    add_index :log_entries, :ran_at
  end
end
