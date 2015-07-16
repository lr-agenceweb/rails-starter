class CreateGuestBooks < ActiveRecord::Migration
  def change
    create_table :guest_books do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.text :content, null: false
      t.string :lang, null: false
      t.boolean :validated, default: false

      t.timestamps null: false
    end
  end
end
