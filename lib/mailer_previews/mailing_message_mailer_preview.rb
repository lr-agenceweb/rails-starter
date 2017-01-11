# frozen_string_literal: true

#
# MailingMessage Mailer preview
# http://localhost:3000/rails/mailers/mailing_message_preview
# ================================
class MailingMessageMailerPreview < ActionMailer::Preview
  def mailing_message_preview
    @mailing_user = MailingUser.new(
      id: 1,
      email: 'test@test.fr',
      fullname: 'Testeur',
      token: '1234567-AZ',
      lang: 'fr'
    )
    @mailing_message = MailingMessage.first.decorate
    @mailing_setting = MailingSetting.first.decorate

    MailingMessageMailer.send_email(opts)
  end

  private

  def opts
    {
      mailing_user: @mailing_user,
      mailing_message: @mailing_message,
      mailing_setting: @mailing_setting
    }
  end
end
