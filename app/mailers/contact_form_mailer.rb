#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  default to: Setting.first.try(:email)
  layout 'contact'

  def message_me(message)
    @message = message
    @message.subject = I18n.t('contact.email.subject', site: @settings.title, locale: I18n.default_locale)
    @host = Figaro.env.application_host
    @map = Map.first
    mail(from: @message.email, subject: @message.subject) do |format|
      format.html
      format.text
    end
  end

  def send_copy(message)
    @message = message
    mail from: @settings.email,
         to: @message.email,
         subject: I18n.t('contact.email.subject_cc', site: @settings.title),
         body: @message.message
  end
end
