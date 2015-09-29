class AddOptionalModuleIdToStringBox < ActiveRecord::Migration
  def change
    add_reference :string_boxes, :optional_module, index: true, foreign_key: true, after: :content
  end
end
