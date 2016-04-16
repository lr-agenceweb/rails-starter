# frozen_string_literal: true
#
# == MailingMessage Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/mailing_message_preview
#
class MailingMessageMailerPreview < ActionMailer::Preview
  def mailing_message_preview
    @mailing_user = MailingUser.new(id: 1, email: 'test@test.fr', fullname: 'Testeur', token: '1234567-AZ', lang: 'en')
    MailingMessageMailer.send_email(@mailing_user, MailingMessage.first)
  end
end
