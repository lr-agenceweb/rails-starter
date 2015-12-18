class AddKeyToEventOrder < ActiveRecord::Migration
  def change
    add_column :event_orders, :key, :string, after: :id
  end
end
