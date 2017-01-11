# frozen_string_literal: true

#
# MailingMessage Mailer
# =======================
class MailingMessageMailer < ApplicationMailer
  layout 'mailers/mailing'

  # Callbacks
  before_action :set_variables

  # Administrator => Customer
  def send_email(opts)
    extract_vars(opts)
    subject = I18n.with_locale(@mailing_user.lang) do
      default_i18n_subject(site: @setting.title, title: @mailing_message.title)
    end

    mail from: optimize_from_header,
         to: @mailing_user.email,
         subject: subject do |format|
      format.html
      format.text { render layout: 'mailers/default' }
    end
  end

  private

  def set_variables
    @show_in_email = true
    @hide_preview_link = false
  end

  def extract_vars(opts)
    @mailing_user ||= opts[:mailing_user]
    @mailing_message ||= opts[:mailing_message]
    @mailing_setting ||= opts[:mailing_setting]
  end

  def optimize_from_header
    "#{@mailing_setting.name_status} <#{@mailing_setting.email_status}>"
  end
end
