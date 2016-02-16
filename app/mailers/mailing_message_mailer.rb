#
# == MailingMessage Mailer
#
class MailingMessageMailer < ApplicationMailer
  add_template_helper(HtmlHelper)
  layout 'mailing'

  # Email MailingMessage
  def send_email(mailing_user, mailing_message)
    @mailing_user = mailing_user
    I18n.with_locale(@mailing_user.lang) do
      @mailing_setting = MailingSetting.first
      @mailing_message = MailingMessage.find(mailing_message.id)
      @title = @mailing_message.title
      @content = @mailing_message.content
      @show_in_email = true
      @hide_preview_link = false

      mail(
        to: @mailing_user.email,
        subject: @title,
        from: "#{MailingSetting.first.decorate.name_status} <#{MailingSetting.first.decorate.email_status}>"
      ) do |format|
        format.html
        format.text
      end
    end
  end
end
