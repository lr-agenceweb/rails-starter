class AddEmailToGuestBook < ActiveRecord::Migration
  def change
    add_column :guest_books, :email, :string, after: :username, null: false
  end
end
