#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  default to: Setting.first.try(:email)
  layout 'contact'

  before_action :set_settings

  def message_me(message)
    @message = message
    @message.subject = I18n.t('contact.email.subject', site: @settings.title, locale: I18n.default_locale)
    mail from: @message.email,
         subject: @message.subject,
         body: @message.message do |format|
      format.html
      format.text
    end
  end

  def send_copy(message)
    @message = message
    @copy_to_sender = true
    @message.subject = I18n.t('contact.email.subject_cc', site: @settings.title, locale: I18n.default_locale)
    mail from: @settings.email,
         to: @message.email,
         subject: I18n.t('contact.email.subject_cc', site: @settings.title),
         body: @message.message do |format|
      format.html { render :message_me }
      format.text { render :message_me }
    end
  end

  private

  def set_settings
    @map = Map.first
    @host = Figaro.env.application_host
    @copy_to_sender = false
  end
end
