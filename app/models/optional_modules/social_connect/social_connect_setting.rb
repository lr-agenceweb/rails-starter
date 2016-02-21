# == Schema Information
#
# Table name: social_connect_settings
#
#  id         :integer          not null, primary key
#  enabled    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == SocialConnectSetting Model
#
class SocialConnectSetting < ActiveRecord::Base
  has_many :social_providers
  accepts_nested_attributes_for :social_providers, reject_if: :all_blank, allow_destroy: true
end
