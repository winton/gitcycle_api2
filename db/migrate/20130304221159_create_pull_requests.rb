class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :number
      t.string  :status
      t.string  :url
      t.integer :ticket_id
      t.integer :user_id

      t.timestamps
    end
  end
end
