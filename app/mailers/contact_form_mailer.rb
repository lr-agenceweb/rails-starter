#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  default to: Setting.first.try(:email)

  def message_me(message)
    @message = message
    mail from: @message.email,
         subject: I18n.t('contact.email.subject', site: @settings.title, locale: I18n.default_locale),
         body: @message.message
  end
end
