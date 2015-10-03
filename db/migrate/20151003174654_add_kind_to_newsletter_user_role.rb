class AddKindToNewsletterUserRole < ActiveRecord::Migration
  def change
    add_column :newsletter_user_roles, :kind, :string, after: :title
  end
end
