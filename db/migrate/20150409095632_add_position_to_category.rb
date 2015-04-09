class AddPositionToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :position, :integer, after: :show_in_footer
  end
end
