class AddAllowCommentsToPostAndBlog < ActiveRecord::Migration
  def change
    add_column :posts, :allow_comments, :boolean, default: true, after: :content
    add_column :blogs, :allow_comments, :boolean, default: true, after: :content
  end
end
