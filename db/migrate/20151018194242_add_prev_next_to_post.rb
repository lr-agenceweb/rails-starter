class AddPrevNextToPost < ActiveRecord::Migration
  def change
    add_column :posts, :prev_next, :boolean, default: true, after: :online
    add_column :blogs, :prev_next, :boolean, default: true, after: :online
    add_column :events, :prev_next, :boolean, default: true, after: :online
  end
end
