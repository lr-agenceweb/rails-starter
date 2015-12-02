# == Schema Information
#
# Table name: string_boxes
#
#  id                 :integer          not null, primary key
#  key                :string(255)
#  title              :string(255)
#  content            :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  optional_module_id :integer
#
# Indexes
#
#  index_string_boxes_on_key                 (key)
#  index_string_boxes_on_optional_module_id  (optional_module_id)
#

#
# == StringBox Model
#
class StringBox < ActiveRecord::Base
  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content

  belongs_to :optional_module
end
