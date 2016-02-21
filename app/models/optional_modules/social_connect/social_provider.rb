# == Schema Information
#
# Table name: social_providers
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  enabled                   :boolean          default(TRUE)
#  social_connect_setting_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_social_providers_on_social_connect_setting_id  (social_connect_setting_id)
#

#
# == SocialProvider Model
#
class SocialProvider < ActiveRecord::Base
  belongs_to :social_connect_setting

  def self.allowed_social_providers
    User.omniauth_providers.map(&:to_s)
  end

  validates :name,
            presence: true,
            allow_blank: false,
            uniqueness: {
              case_sensitive: false
            },
            inclusion: { in: allowed_social_providers }

  def self.provider_by_name(name)
    find_by(name: name)
  end

  def self.allowed_to_use?
    OptionalModule.find_by(name: 'SocialConnect').enabled? && SocialConnectSetting.first.enabled?
  end
end
