# frozen_string_literal: true

#
# == Comment Mailer
#
class CommentMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  layout 'comment'

  # Email sent when comment is being created
  def comment_created(comment)
    I18n.with_locale(comment.lang) do
      set_comment_variables(comment)
      @comment.subject = I18n.t('comment.created.email.subject', site: @setting.title)
      @content = I18n.t('comment.created.email.content', date: @comment.decorate.created_at(:long), article: @commentable.title, link: link_to(@link, @link, target: :blank), link_admin: link_to(@link, admin_post_comment_url(@comment), target: :blank))
    end

    user_to_admin 'comment_validated'
  end

  # Email sent when comment is being signalled
  def comment_signalled(comment)
    @comment = comment
    @comment.subject = I18n.t('comment.signalled.email.subject', site: @setting.title, locale: I18n.default_locale)
    @content = I18n.t('comment.signalled.email.content', user: @comment.decorate.pseudo_registered_or_guest, locale: I18n.default_locale)

    user_to_admin 'comment_signalled'
  end

  # Email sent when comment is being validated
  def comment_validated(comment)
    I18n.with_locale(comment.lang) do
      set_comment_variables(comment)
    end
    admin_to_user
  end

  private

  def set_link
    anchor = "comment-#{@comment.id}"
    @link = @comment.commentable_type == 'Blog' ? blog_category_blog_url(@commentable.blog_category, @commentable, anchor: anchor) : polymorphic_url(@commentable, anchor: "#{anchor}")
  end

  def set_comment_variables(comment)
    @comment = Comment.find(comment.id).decorate
    @commentable = @comment.commentable
    set_link
    @comment.subject = I18n.t('comment.validated.email.subject', site: @setting.title)
    @greeting = I18n.t('comment.email.greeting', author: @comment.pseudo_registered_or_guest)
    @content = I18n.t('comment.validated.email.content', date: @comment.decorate.created_at(:long), article: @commentable.title, link: link_to(@link, @link, target: :blank))
  end

  def admin_to_user
    mail from: @setting.email,
         to: @comment.email_registered_or_guest,
         subject: @comment.subject do |format|
      format.html
      format.text
    end
  end

  def user_to_admin(template)
    mail from: @comment.decorate.email_registered_or_guest,
         to: @setting.email,
         subject: @comment.subject do |format|
      format.html { render template }
      format.text { render template }
    end
  end
end
