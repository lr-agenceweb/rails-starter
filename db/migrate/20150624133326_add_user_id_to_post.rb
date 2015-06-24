class AddUserIdToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :user, index: true, after: :online
    add_foreign_key :posts, :users
  end
end
