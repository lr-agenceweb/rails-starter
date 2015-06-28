class AddValidatedToComment < ActiveRecord::Migration
  def change
    add_column :comments, :validated, :boolean, default: true, after: :commentable_type
  end
end
