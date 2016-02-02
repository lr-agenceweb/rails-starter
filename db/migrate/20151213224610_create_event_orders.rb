class CreateEventOrders < ActiveRecord::Migration
  def change
    create_table :event_orders do |t|
      t.string :key
      t.string :name

      t.timestamps null: false
    end
  end
end
