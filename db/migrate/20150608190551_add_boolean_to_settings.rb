class AddBooleanToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :show_breadcrumb, :boolean, default: 0, after: :show_map
    add_column :settings, :show_social, :boolean, default: 1, after: :show_breadcrumb
  end
end
