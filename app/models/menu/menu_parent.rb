# == Schema Information
#
# Table name: menu_parents
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  online         :boolean          default(TRUE)
#  show_in_footer :boolean          default(FALSE)
#  category_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_menu_parents_on_category_id  (category_id)
#

#
# == MenuParent Model (parent)
#
class MenuParent < ActiveRecord::Base
  translates :title, fallbacks_for_empty_translations: true
  active_admin_translates :title

  has_many :menu_children
end
