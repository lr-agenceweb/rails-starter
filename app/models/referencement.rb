# frozen_string_literal: true

#
# == Referencement Model
#
class Referencement < ApplicationRecord
  translates :title, :description, :keywords, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description, :keywords, fallbacks_for_empty_translations: true

  belongs_to :attachable, polymorphic: true, touch: true
end

# == Schema Information
#
# Table name: referencements
#
#  id              :integer          not null, primary key
#  attachable_type :string(255)
#  attachable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_referencements_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
