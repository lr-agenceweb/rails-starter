class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :name
      t.string :title
      t.string :subtitle
      t.string :phone
      t.string :phone_secondary, default: nil
      t.string :email
      t.integer :per_page, default: 3
      t.boolean :show_breadcrumb, default: false
      t.boolean :show_social, default: true
      t.boolean :show_qrcode, default: false
      t.boolean :maintenance, default: false
      t.string :twitter_username, default: nil

      t.timestamps null: false
    end
    Setting.create_translation_table! title: :string, subtitle: :string
  end

  def down
    drop_table :settings
    Setting.drop_translation_table!
  end
end
