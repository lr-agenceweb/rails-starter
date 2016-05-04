class AddMoreOptionsToBlogSetting < ActiveRecord::Migration
  def change
    add_column :blog_settings, :show_last_posts, :boolean, default: true, after: :prev_next
    add_column :blog_settings, :show_categories, :boolean, default: true, after: :show_last_posts
  end
end
