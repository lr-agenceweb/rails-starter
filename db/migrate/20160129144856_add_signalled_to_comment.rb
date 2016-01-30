class AddSignalledToComment < ActiveRecord::Migration
  def change
    add_column :comments, :signalled, :boolean, default: false, after: :validated
  end
end
