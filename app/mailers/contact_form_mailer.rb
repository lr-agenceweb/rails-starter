#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  default to: Setting.first.try(:email)
  layout :contact

  def message_me(message)
    @message = message
    mail from: @message.email,
         subject: I18n.t('contact.email.subject', site: @settings.title, locale: I18n.default_locale),
         body: @message.message
  end

  def send_copy(message)
    @message = message
    mail from: @settings.email,
         to: @message.email,
         subject: I18n.t('contact.email.subject_cc', site: @settings.title),
         body: @message.message
  end
end
