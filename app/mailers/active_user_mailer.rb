# frozen_string_literal: true

#
# ActiveUser Mailer
# ===================
class ActiveUserMailer < ApplicationMailer
  layout 'mailers/default'

  def send_email(user)
    @user = user

    mail from: @from_admin,
         to: @user.email,
         subject: default_i18n_subject(site: @setting.title) do |format|
      format.html
      format.text
    end
  end
end
