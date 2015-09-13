class AddShowInHeaderToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :show_in_header, :boolean, after: :online, default: true
  end
end
