class RemoveUrlToEvent < ActiveRecord::Migration
  def change
    remove_column :events, :url
  end
end
