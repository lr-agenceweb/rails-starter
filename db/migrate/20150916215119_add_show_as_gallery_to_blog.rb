class AddShowAsGalleryToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :show_as_gallery, :boolean, after: :allow_comments, default: false
  end
end
