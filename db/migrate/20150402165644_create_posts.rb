class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string :type
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :online, default: true
      t.references :user, index: true

      t.timestamps null: false
    end
    Post.create_translation_table! title: :string, slug: :string, content: :text

    add_index :posts, :slug, unique: true
  end

  def down
    drop_table :posts
    Post.drop_translation_table!
  end
end
