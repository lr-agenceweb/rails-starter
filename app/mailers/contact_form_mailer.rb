# frozen_string_literal: true

#
# ContactForm Mailer
# ====================
class ContactFormMailer < ApplicationMailer
  layout 'mailers/default'

  # Customer => Administrator
  def to_admin(message, locale)
    @message = message

    if message.attachment && @setting.show_file_upload?
      attachment_name = message.attachment.original_filename
      attachments[attachment_name] = message.attachment.read
    end

    I18n.with_locale(locale) { mail_method(@message.email, @from_admin) }
  end

  # Administrator => Customer
  def copy(message, locale)
    @message = message
    @copy_to_sender = true

    I18n.with_locale(locale) { mail_method(@from_admin, @message.email) }
  end

  # Administrator => Customer
  def answering_machine(message_email, locale)
    I18n.with_locale(locale) do
      sb_answering_machine
      mail_method(@from_admin, message_email, template: :answering_machine)
    end
  end

  private

  def mail_method(from, to, template: :to_admin)
    subject = @subject || default_i18n_subject(site: @setting.title)

    mail from: from,
         to: to,
         subject: subject do |format|
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
