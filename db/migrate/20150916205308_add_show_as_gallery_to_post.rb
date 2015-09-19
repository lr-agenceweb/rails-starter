class AddShowAsGalleryToPost < ActiveRecord::Migration
  def change
    add_column :posts, :show_as_gallery, :boolean, after: :content, default: false
  end
end
