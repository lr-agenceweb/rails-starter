# == Schema Information
#
# Table name: string_boxes
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  title      :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_string_boxes_on_key  (key)
#

#
# == StringBox Model
#
class StringBox < ActiveRecord::Base
  translates :title, :content, fallbacks_for_empty_translations: true
  active_admin_translates :title, :content
end
