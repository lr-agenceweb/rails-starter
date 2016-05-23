# frozen_string_literal: true

#
# == Comment Mailer
#
class CommentMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

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

  def send_validated_comment(comment)
    I18n.with_locale(comment.lang) do
      @comment = Comment.find(comment.id).decorate
      @commentable = @comment.commentable
      set_link
      @comment.subject = I18n.t('comment.validated.email.subject', site: @setting.title)
      @greeting = I18n.t('comment.email.greeting', author: @comment.pseudo_registered_or_guest)
      @content = I18n.t('comment.validated.email.content', date: @comment.created_at, article: @commentable.title, link: link_to(@link, @link, target: :blank))
    end

    mail from: @setting.email,
         to: @comment.email_registered_or_guest,
         subject: @comment.subject do |format|
      format.html
      format.text
    end
  end

  private

  def set_link
    @link = @comment.commentable_type == 'Blog' ? blog_category_blog_url(@commentable.blog_category, @commentable) : polymorphic_url(@commentable)
  end
end
