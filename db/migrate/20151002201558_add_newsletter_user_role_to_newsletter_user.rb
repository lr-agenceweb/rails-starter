class AddNewsletterUserRoleToNewsletterUser < ActiveRecord::Migration
  def change
    add_reference :newsletter_users, :newsletter_user_role, default: 1, index: true, foreign_key: true, after: :token
    remove_column :newsletter_users, :role
  end
end
