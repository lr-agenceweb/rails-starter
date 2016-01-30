class AddAncestryToComment < ActiveRecord::Migration
  def change
    add_column :comments, :ancestry, :string, after: :signalled
    add_index :comments, :ancestry
  end
end
