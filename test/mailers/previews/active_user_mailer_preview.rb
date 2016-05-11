# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/active_user_mailer

#
# == ActiveUser Mailer preview
#
class ActiveUserMailerPreview < ActionMailer::Preview
  def send_message_preview
    @user = User.last
    ActiveUserMailer.send_email(@user)
  end
end
