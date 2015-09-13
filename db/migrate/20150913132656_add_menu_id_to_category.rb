class AddMenuIdToCategory < ActiveRecord::Migration
  def change
    add_reference :categories, :menu, index: true, foreign_key: true, after: :optional_module_id
  end
end
