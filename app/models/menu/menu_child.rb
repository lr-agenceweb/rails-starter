# == Schema Information
#
# Table name: menu_children
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  online         :boolean          default(TRUE)
#  menu_parent_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_menu_children_on_menu_parent_id  (menu_parent_id)
#

#
# == MenuChild Model (child)
#
class MenuChild < ActiveRecord::Base
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title

  belongs_to :menu_parent
end
