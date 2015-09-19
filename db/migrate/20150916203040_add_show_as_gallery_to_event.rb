class AddShowAsGalleryToEvent < ActiveRecord::Migration
  def change
    add_column :events, :show_as_gallery, :boolean, after: :end_date, default: false
  end
end
