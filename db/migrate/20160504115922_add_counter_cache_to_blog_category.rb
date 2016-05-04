class AddCounterCacheToBlogCategory < ActiveRecord::Migration
  def change
    add_column :blog_categories, :blogs_count, :integer, default: 0, null: false, after: :slug
  end
end
