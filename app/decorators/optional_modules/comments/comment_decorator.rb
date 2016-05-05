# frozen_string_literal: false
#
# == CommentDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  #
  # == Extract pseudo and email from comment
  #
  def pseudo_registered_or_guest
    name = model.try(:user_id).nil? ? model.username : model.user_username
    name.capitalize
  end

  def email_registered_or_guest
    model.try(:user_id).nil? ? model.email : model.user_email
  end

  #
  # == Avatar associated to comment
  #
  def avatar
    # Not connected
    if model.try(:user_id).nil?
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width), secure: true })

    # Connected
    else
      retina_thumb_square(model.user, @avatar_width)
    end
  end

  def author_with_avatar
    author_with_avatar_html(avatar, pseudo_registered_or_guest)
  end

  #
  # == Link and Image for Commentable
  #
  def link_source
    link = commentable.is_a?(Blog) ? blog_category_blog_path(commentable.blog_category, commentable) : polymorphic_path(commentable)
    link_to commentable.title, link, target: :_blank
  end

  def image_source
    h.retina_image_tag commentable.pictures.first, :image, :small
  end

  def link_and_image_source
    html = ''
    html << content_tag(:p, image_source) if commentable_image?
    html << content_tag(:p, link_source)
    html.html_safe
  end

  #
  # == Status tag
  #
  def signalled_d
    color = model.signalled? ? 'red' : 'green'
    status_tag_deco(I18n.t(model.signalled.to_s), color)
  end

  def pseudo(name = nil)
    name = pseudo_registered_or_guest if name.nil?
    content_tag(:strong, name, class: 'comment-author')
  end

  private

  def commentable_image?
    commentable.pictures.present?
  end
end
