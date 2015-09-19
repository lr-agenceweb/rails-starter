class AddPositionToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :position, :integer, after: :primary
  end
end
