# frozen_string_literal: true
# == Schema Information
#
# Table name: headings
#
#  id               :integer          not null, primary key
#  content          :text(65535)
#  headingable_id   :integer
#  headingable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_headings_on_headingable_type_and_headingable_id  (headingable_type,headingable_id)
#

#
# == Heading Model
#
class Heading < ActiveRecord::Base
  translates :content, fallbacks_for_empty_translations: true
  active_admin_translates :content
end
