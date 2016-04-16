# frozen_string_literal: true
#
# == Comment Mailer
#
class CommentMailer < ApplicationMailer
  default to: Setting.first.try(:email)
  layout 'comment'

  def send_email(comment)
    @comment = comment
    @comment.subject = I18n.t('comment.signalled.email.subject', site: @setting.title, locale: I18n.default_locale)
    @content = I18n.t('comment.signalled.email.content', user: @comment.decorate.pseudo_registered_or_guest, locale: I18n.default_locale)

    mail from: @comment.decorate.email_registered_or_guest,
         subject: @comment.subject do |format|
      format.html
      format.text
    end
  end
end
