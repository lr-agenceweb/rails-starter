class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end
  end
end
