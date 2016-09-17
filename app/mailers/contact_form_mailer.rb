# frozen_string_literal: true

#
# == ContactForm Mailer
#
class ContactFormMailer < ApplicationMailer
  before_action :set_answering_machine

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

  # Administrator => Customer
  def answering_machine(message_email)
    mail_method(@setting.email, message_email, @message, :answering_machine)
  end

  private

  def mail_method(from, to, body = @message.message, template = :message_me)
    subject = try(:@subject) || default_i18n_subject(site: @setting.title, locale: I18n.default_locale)

    mail from: from,
         to: to,
         subject: subject,
         body: body do |format|
      format.html { render template }
      format.text { render template }
    end
  end

  def set_answering_machine
    sb = StringBox.includes(:translations).find_by(key: 'answering_machine')
    @subject = sb.title
    @message = sb.content
  rescue
    @message = t('contact_form_mailer.answering_machine.content')
  end
end
