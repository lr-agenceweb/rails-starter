class AddBooleanToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :show_breadcrumb, :boolean, default: false, after: :show_map
    add_column :settings, :show_social, :boolean, default: true, after: :show_breadcrumb
  end
end
