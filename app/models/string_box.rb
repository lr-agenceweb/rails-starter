# frozen_string_literal: true
# == Schema Information
#
# Table name: string_boxes
#
#  id                 :integer          not null, primary key
#  key                :string(255)
#  description        :text(65535)
#  optional_module_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
  translates :title, :content
  active_admin_translates :title, :content

  belongs_to :optional_module
end
