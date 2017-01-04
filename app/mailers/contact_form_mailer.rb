# frozen_string_literal: true

#
# ContactForm Mailer
# ====================
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
    mail_method(@from_admin, @message.email)
  end

  # Administrator => Customer
  def answering_machine(message_email, locale = I18n.default_locale)
    I18n.with_locale(locale) do
      sb_answering_machine
      mail_method(@from_admin, message_email, @message, :answering_machine, locale)
    end
  end

  private

  def mail_method(from, to, body = @message.message, template = :message_me, locale = I18n.default_locale)
    subject = @subject || default_i18n_subject(site: @setting.title, locale: locale)

    mail from: from,
         to: to,
         subject: subject,
         body: body do |format|
      format.html { render template }
      format.text { render template }
    end
  end

  def sb_answering_machine
    sb = StringBox.includes(:translations).find_by(key: 'answering_machine')
    @subject = sb.title unless sb.title.blank?
    @message = sb.content.blank? ? t('contact_form_mailer.answering_machine.content') : sb.content
  rescue
    @message = t('contact_form_mailer.answering_machine.content')
  end
end
