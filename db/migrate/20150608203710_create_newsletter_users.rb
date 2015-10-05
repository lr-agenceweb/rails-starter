class CreateNewsletterUsers < ActiveRecord::Migration
  def change
    create_table :newsletter_users do |t|
      t.string :email
      t.string :lang, default: 'fr'
      t.string :token
      t.references :newsletter_user_role, index: true

      t.timestamps null: false
    end

    add_index :newsletter_users, :email, unique: true
  end
end
