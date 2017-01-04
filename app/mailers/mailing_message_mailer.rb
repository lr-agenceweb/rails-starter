# frozen_string_literal: true

#
# MailingMessage Mailer
# =======================
class MailingMessageMailer < ApplicationMailer
  add_template_helper(HtmlHelper)
  layout 'mailers/mailing'

  before_action :set_variables

  # Email MailingMessage
  def send_email(mailing_user, mailing_message)
    @mailing_user = mailing_user
    I18n.with_locale(@mailing_user.lang) do
      @mailing_setting = MailingSetting.first.decorate
      @mailing_message = MailingMessage.find(mailing_message.id)
      @content = @mailing_message.content

      mail from: "#{@mailing_setting.name_status} <#{@mailing_setting.email_status}>",
           to: @mailing_user.email,
           subject: default_i18n_subject(site: @setting.title, title: @mailing_message.title) do |format|
        format.html
        format.text { render layout: 'mailers/default' }
      end
    end
  end

  private

  def set_variables
    @show_in_email = true
    @hide_preview_link = false
  end
end
