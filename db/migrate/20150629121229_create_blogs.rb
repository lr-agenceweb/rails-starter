class CreateBlogs < ActiveRecord::Migration
  def up
    create_table :blogs do |t|
      t.string :title
      t.string :slug, index: true, unique: true
      t.text :content
      t.boolean :online, default: true
      t.references :user, index: true

      t.timestamps null: false
    end

    Blog.create_translation_table! title: :string, slug: :string, content: :text
  end

  def down
    drop_table :blogs
    Blog.drop_translation_table!
  end
end
