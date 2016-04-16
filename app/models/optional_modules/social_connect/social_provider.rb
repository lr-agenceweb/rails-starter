# frozen_string_literal: true
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

  def self.format_provider_by_name(name)
    case name
    when 'google_oauth2'
      name = 'google'
    else
      name
    end
  end

  def self.revert_format_provider_by_name(name)
    case name
    when 'google'
      name = 'google_oauth2'
    else
      name
    end
  end

  def self.allowed_social_providers
    providers = []
    User.omniauth_providers.each do |provider|
      provider = format_provider_by_name(provider.to_s)
      providers << provider.to_s unless ENV["#{provider}_app_id"].blank? || ENV["#{provider}_app_secret"].blank?
    end
    providers
  end

  validates :name,
            presence: true,
            allow_blank: false,
            uniqueness: {
              case_sensitive: false
            },
            inclusion: { in: allowed_social_providers }

  scope :enabled, -> { where(enabled: true) }

  def self.provider_by_name(name)
    find_by(name: name)
  end

  def self.allowed_to_use?
    OptionalModule.find_by(name: 'SocialConnect').enabled? && SocialConnectSetting.first.enabled?
  end
end
