class AddDescriptionToStringBox < ActiveRecord::Migration
  def change
    add_column :string_boxes, :description, :text, after: :key
  end
end
