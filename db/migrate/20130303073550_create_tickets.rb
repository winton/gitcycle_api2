class CreateTickets < ActiveRecord::Migration

  def change
    create_table :tickets do |t|
      t.string  :service
      t.integer :number
      t.string  :status
      t.string  :title
      t.string  :url,  limit: 256
      t.string  :body, limit: 10240

      t.integer :lighthouse_project_id

      t.integer :assigned_lighthouse_user_id
      t.integer :lighthouse_user_id

      t.datetime :ticket_created_at
      t.datetime :ticket_updated_at

      t.timestamps
    end
  end
end
