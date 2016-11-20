# frozen_string_literal: true

#
# == Comment Mailer
#
class CommentMailer < ApplicationMailer
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  layout 'mailers/default'

  # Email sent when comment is being created
  def comment_created(comment)
    I18n.with_locale(comment.lang) do
      define_comment_variables(comment)
    end

    user_to_admin 'comment_created'
  end

  # Email sent when comment is being signalled
  def comment_signalled(comment)
    I18n.with_locale(comment.lang) do
      define_comment_variables(comment)
    end
    user_to_admin 'comment_signalled'
  end

  # Email sent when comment is being validated
  def comment_validated(comment)
    I18n.with_locale(comment.lang) do
      define_comment_variables(comment)
    end
    admin_to_user
  end

  private

  def define_comment_variables(comment)
    @comment = Comment.find(comment.id).decorate
    @commentable = @comment.commentable
    set_link
  end

  def set_link
    anchor = "comment-#{@comment.id}"
    @link = @comment.commentable_type == 'Blog' ? blog_category_blog_url(@commentable.blog_category, @commentable, anchor: anchor) : polymorphic_url(@commentable, anchor: anchor)
  end

  def admin_to_user
    mail from: @setting.email,
         to: @comment.email_registered_or_guest,
         subject: default_i18n_subject(site: @setting.title) do |format|
      format.html
      format.text
    end
  end

  def user_to_admin(template)
    mail from: @comment.decorate.email_registered_or_guest,
         to: @setting.email,
         subject: default_i18n_subject(site: @setting.title) do |format|
      format.html { render template }
      format.text { render template }
    end
  end
end
