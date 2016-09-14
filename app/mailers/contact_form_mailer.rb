# frozen_string_literal: true

#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  layout 'mailers/default'

  # Customer => Administrator
  def message_me(message)
    @message = message

    if message.attachment && @setting.show_file_upload?
      attachment_name = message.attachment.original_filename
      attachments[attachment_name] = message.attachment.read
    end

    mail_method(@message.email, @setting.email)
  end

  # Administrator => Customer
  def send_copy(message)
    @message = message
    @copy_to_sender = true
    mail_method(@setting.email, @message.email)
  end

  private

  def mail_method(from, to, template = :message_me)
    mail from: from,
         to: to,
         subject: default_i18n_subject(site: @setting.title, locale: I18n.default_locale),
         body: @message.message do |format|
      format.html { render template }
      format.text { render template }
    end
  end
end
