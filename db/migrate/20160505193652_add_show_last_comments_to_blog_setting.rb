class AddShowLastCommentsToBlogSetting < ActiveRecord::Migration
  def change
    add_column :blog_settings, :show_last_comments, :boolean, after: :show_categories, default: false
  end
end
