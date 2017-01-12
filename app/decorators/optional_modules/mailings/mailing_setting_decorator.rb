# frozen_string_literal: true

#
# MailingSettingDecorator
# =========================
class MailingSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def name_status
    return name unless model.name.blank?
    Setting.first.name
  end

  def email_status
    return email unless model.email.blank?
    Setting.first.email
  end

  def signature
    s = model.signature.blank? ? name_status : model.signature
    safe_join [raw(s)]
  end

  def unsubscribe_content
    safe_join [raw(model.unsubscribe_content)]
  end
end
