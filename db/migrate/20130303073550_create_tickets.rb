class CreateTickets < ActiveRecord::Migration

  def change
    create_table :tickets do |t|
      t.string :service
      t.integer :number
      t.string :title
      t.string :url,  limit: 256
      t.string :body, limit: 10240

      t.datetime :ticket_created_at
      t.datetime :ticket_updated_at

      t.timestamps
    end
  end
end
