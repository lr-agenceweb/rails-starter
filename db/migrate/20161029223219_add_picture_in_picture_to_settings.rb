class AddPictureInPictureToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :picture_in_picture, :boolean, default: true, after: :answering_machine
  end
end
