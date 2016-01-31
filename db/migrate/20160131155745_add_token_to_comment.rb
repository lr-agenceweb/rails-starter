class AddTokenToComment < ActiveRecord::Migration
  def change
    add_column :comments, :token, :string, after: :comment
  end
end
