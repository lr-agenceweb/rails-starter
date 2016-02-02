class CreateGuestBookSettings < ActiveRecord::Migration
  def change
    create_table :guest_book_settings do |t|
      t.boolean :should_validate, default: true

      t.timestamps null: false
    end
  end
end
