class CreateGuestBooks < ActiveRecord::Migration
  def change
    create_table :guest_books do |t|
      t.string :username
      t.text :content
      t.string :lang
      t.boolean :online, default: true

      t.timestamps null: false
    end
  end
end
