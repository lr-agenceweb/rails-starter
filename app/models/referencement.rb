# frozen_string_literal: true

# == Schema Information
#
# Table name: referencements
#
#  id              :integer          not null, primary key
#  attachable_id   :integer
#  attachable_type :string(255)
#  title           :string(255)
#  description     :text(65535)
#  keywords        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_referencements_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

#
# Referencement Model
# =======================
class Referencement < ApplicationRecord
  translates :title, :description, :keywords,
             fallbacks_for_empty_translations: true
  active_admin_translates :title, :description, :keywords, fallbacks_for_empty_translations: true

  # Model relations
  belongs_to :attachable, polymorphic: true, touch: true
end
