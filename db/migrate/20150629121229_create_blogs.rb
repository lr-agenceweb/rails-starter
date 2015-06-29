class CreateBlogs < ActiveRecord::Migration
  def up
    create_table :blogs do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :online, default: true
      t.references :user

      t.timestamps null: false
    end
    Blog.create_translation_table! title: :string, slug: :string, content: :text

    add_index :blogs, :slug, unique: true
    add_foreign_key :blogs, :users
  end

  def down
    drop_table :blogs
    Blog.drop_translation_table!
  end
end
