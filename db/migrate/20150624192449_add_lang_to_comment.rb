class AddLangToComment < ActiveRecord::Migration
  def change
    add_column :comments, :lang, :string, after: :comment
  end
end
