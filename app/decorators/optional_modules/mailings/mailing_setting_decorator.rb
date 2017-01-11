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

  def signature_d
    safe_join [raw(model.signature)]
  end

  def unsubscribe_content
    safe_join [raw(model.unsubscribe_content)]
  end
end
