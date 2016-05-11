# frozen_string_literal: true

#
# == ActiveUser Mailer
#
class ActiveUserMailer < ApplicationMailer
  def send_email(user)
    @user = user
    @subject = I18n.t('user.email.account_validated.subject', site: @setting.title, locale: I18n.default_locale)
    @content = I18n.t('user.email.account_validated.content', site: @setting.title, locale: I18n.default_locale)

    mail from: @setting.email,
         to: @user.email,
         subject: @subject do |format|
      format.html
      format.text
    end
  end
end
