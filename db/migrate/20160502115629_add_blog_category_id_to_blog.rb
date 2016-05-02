class AddBlogCategoryIdToBlog < ActiveRecord::Migration
  def change
    add_reference :blogs, :blog_category, index: true, foreign_key: true, after: :user_id
  end
end
