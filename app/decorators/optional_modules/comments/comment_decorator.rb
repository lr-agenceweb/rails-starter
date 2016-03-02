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
  # == Date
  #
  def comment_created_at
    content_tag(:small, time_tag(model.created_at.to_datetime, l(model.created_at, format: :with_time)))
  end

  #
  # == Link and Image for Commentable
  #
  def link_source
    link_to commentable.title, polymorphic_path(commentable), target: :_blank
  end

  def image_source
    retina_image_tag commentable.pictures.first, :image, :small
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
  def status
    color = model.validated? ? 'green' : 'orange'
    status_tag_deco(I18n.t("validate.#{model.validated}"), color)
  end

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
