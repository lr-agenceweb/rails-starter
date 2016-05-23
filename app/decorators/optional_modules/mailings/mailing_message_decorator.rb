# frozen_string_literal: true

#
# == MailingMessageDecorator
#
class MailingMessageDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def preview
    html = ''
    I18n.available_locales.each do |locale|
      html += link_to I18n.t('mailing.preview', lang: I18n.t("active_admin.globalize.language.#{locale}")), send("preview_admin_mailing_message_#{locale}_path", model.id), target: :blank
      html += '<br/>'
    end
    raw html
  end

  def live_preview
    render '/admin/mailings/iframe_preview', resource: model
  end

  def sent_at
    model.sent_at_message
  end

  def send_link
    render '/admin/mailings/send', resource: model
  end

  def status
    color = model.already_sent? ? 'red' : 'green'
    status_tag_deco(I18n.t("sent.#{model.already_sent?}"), color)
  end
end
