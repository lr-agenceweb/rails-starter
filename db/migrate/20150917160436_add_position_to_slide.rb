class AddPositionToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :position, :integer, after: :primary
  end
end
