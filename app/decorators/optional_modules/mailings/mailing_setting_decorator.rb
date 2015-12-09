#
# == MailingSettingDecorator
#
class MailingSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def email_status
    return email unless model.email.blank?
    I18n.t('mailing.setting.email', email: Setting.first.email)
  end
end
