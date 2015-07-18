class AddPositionToPost < ActiveRecord::Migration
  def change
    add_column :posts, :position, :integer, after: :online
  end
end
