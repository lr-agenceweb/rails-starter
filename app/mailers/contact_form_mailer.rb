# frozen_string_literal: true

#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  layout 'contact'

  # Customer => Administrator
  def message_me(message)
    @message = message

    if message.attachment && @setting.show_file_upload?
      attachment_name = message.attachment.original_filename
      attachments[attachment_name] = message.attachment.read
    end

    mail from: @message.email,
         to: @setting.email,
         subject: default_i18n_subject(site: @setting.title, locale: I18n.default_locale),
         body: @message.message do |format|
      format.html
      format.text
    end
  end

  # Administrator => Customer
  def send_copy(message)
    @message = message
    @copy_to_sender = true

    mail from: @setting.email,
         to: @message.email,
         subject: default_i18n_subject(site: @setting.title, locale: I18n.default_locale),
         body: @message.message do |format|
      format.html { render :message_me }
      format.text { render :message_me }
    end
  end
end
