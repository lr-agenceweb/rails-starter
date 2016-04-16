# frozen_string_literal: true
#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  default to: Setting.first.try(:email)
  layout 'contact'

  before_action :set_contact_settings

  def message_me(message)
    @message = message
    @message.subject = I18n.t('contact.email.subject', site: @setting.title, locale: I18n.default_locale)
    mail from: @message.email,
         to: @setting.email,
         subject: @message.subject,
         body: @message.message do |format|
      format.html
      format.text
    end
  end

  def send_copy(message)
    @message = message
    @copy_to_sender = true
    @message.subject = I18n.t('contact.email.subject_cc', site: @setting.title, locale: I18n.default_locale)
    mail from: @setting.email,
         to: @message.email,
         subject: @message.subject,
         body: @message.message do |format|
      format.html { render :message_me }
      format.text { render :message_me }
    end
  end
end
