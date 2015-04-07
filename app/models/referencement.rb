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

#
# == Referencement Model
#
class Referencement < ActiveRecord::Base
  translates :title, :description, :keywords, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description, :keywords, fallbacks_for_empty_translations: true

  belongs_to :attachable, polymorphic: true
end
