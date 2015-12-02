class CreateEventSettings < ActiveRecord::Migration
  def change
    create_table :event_settings do |t|
      t.boolean :prev_next, default: false

      t.timestamps null: false
    end
  end
end
