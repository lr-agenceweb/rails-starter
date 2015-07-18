class CreateNewsletters < ActiveRecord::Migration
  def up
    create_table :newsletters do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.datetime :sent_at

      t.timestamps null: false
    end

    Newsletter.create_translation_table! title: :string, content: :text
  end

  def down
    drop_table :newsletters
    Newsletter.drop_translation_table! migrate_data: true
  end
end
