# frozen_string_literal: true

#
# ActiveUser Mailer
# ===================
class ActiveUserMailer < ApplicationMailer
  layout 'mailers/default'

  def send_email(user)
    @user = user
    @content = I18n.t('active_user_mailer.send_email.content', site: @setting.title)

    mail from: @setting.email,
         to: @user.email,
         subject: default_i18n_subject(site: @setting.title) do |format|
      format.html
      format.text
    end
  end
end
