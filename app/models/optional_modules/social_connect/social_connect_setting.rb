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
  accepts_nested_attributes_for :social_providers, reject_if: :all_blank, allow_destroy: false

  validate :validate_max_row_allowed

  private

  def validate_max_row_allowed
    errors.add :max_row, I18n.t('form.errors.social_connect_setting.max_row') if SocialConnectSetting.count >= 1 && new_record?
  end
end
