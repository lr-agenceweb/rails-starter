#
# == MailingSettingDecorator
#
class MailingSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def email_status
    return email unless model.email.blank?
    Setting.first.email
  end
end
