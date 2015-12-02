class RemoveUnnecessariesColumns < ActiveRecord::Migration
  def change
    remove_column :events, :prev_next
    remove_column :blogs, :prev_next
    remove_column :posts, :prev_next
  end
end
