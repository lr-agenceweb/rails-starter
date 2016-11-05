class RemoveUselessColumnsFromComment < ActiveRecord::Migration
  def change
    remove_column :comments, :title
    remove_column :comments, :role
  end
end
