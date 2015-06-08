class CreateNewsletterUsers < ActiveRecord::Migration
  def change
    create_table :newsletter_users do |t|
      t.string :email
      t.string :lang, default: 'fr'
      t.string :role, default: 'subscriber'
      t.string :token

      t.timestamps null: false
    end

    add_index :newsletter_users, :email, unique: true
  end
end
