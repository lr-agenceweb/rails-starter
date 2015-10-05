class CreateNewsletterUserRoles < ActiveRecord::Migration
  def up
    create_table :newsletter_user_roles do |t|
      t.references :rollable, polymorphic: true, index: true
      t.string :title
      t.string :kind

      t.timestamps null: false
    end

    NewsletterUserRole.create_translation_table! title: :string
  end

  def down
    drop_table :newsletter_user_roles
    NewsletterUserRole.drop_translation_table!
  end
end
