#
# == MailingMessageDecorator
#
class MailingMessageDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def preview
    link_to I18n.t('mailing.preview'), send("preview_cold_calling_message_path", model.id), target: :_blank
  end

  def live_preview
    render '/admin/cold_calling/iframe_preview', resource: model
  end

  def sent_at
    model.sent_at_message
  end

  def send_link
    render '/admin/cold_calling/send', resource: model
  end

  def status
    color = model.already_sent? ? 'red' : 'green'
    status_tag_deco(I18n.t("sent.#{model.already_sent?}"), color)
  end

  def list_subscribers
    render '/admin/cold_calling/list_subscribers', customers: Customer.cold_call_back_no.not_archive
  end
end
