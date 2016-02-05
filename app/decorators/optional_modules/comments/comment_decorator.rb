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
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })

    # Connected
    else
      # Website avatar present
      if model.user.avatar?
        retina_thumb_square(model.user)

      # Website avatar not present (use Gravatar)
      else
        gravatar_image_tag(model.user.email, alt: model.user_username, gravatar: { size: model.class.instance_variable_get(:@avatar_width) })
      end
    end
  end

  def author_with_avatar
    content_tag(:div, nil, class: 'author-with-avatar') do
      concat("#{avatar} <br /> #{pseudo_registered_or_guest}".html_safe)
    end
  end

  #
  # == Content
  #
  def message
    simple_format(model.comment)
  end

  def content
    message
  end

  def comment_created_at
    content_tag(:small, time_tag(model.created_at.to_datetime, l(model.created_at, format: :without_time)))
  end

  #
  # == Article where the Comment comes from
  #
  def source
    model.commentable_type.constantize.find(model.commentable_id)
  end

  #
  # == Link to article where the Comment comes from
  #
  def link_source
    from = source
    if model == 'Post'
      link = send("#{from.type.downcase.underscore.singularize}_path", from)
    else
      link = send('blog_path', from)
    end
    link_to from.title, link, target: :_blank
  end

  #
  # == Image from article where Comment comes from
  #
  def image_source
    from = source
    retina_image_tag from.pictures.first, :image, :small if from.pictures.present?
  end

  #
  # == Link and Image from article where Comment comes from
  #
  def link_and_image_source
    content_tag(:p, image_source) + content_tag(:p, link_source)
  end

  def status
    color = model.validated? ? 'green' : 'orange'
    status_tag_deco(I18n.t("validate.#{model.validated}"), color)
  end

  def signalled_d
    color = model.signalled? ? 'red' : 'green'
    status_tag_deco(I18n.t("#{model.signalled}"), color)
  end

  def pseudo(name = nil)
    name = pseudo_registered_or_guest if name.nil?
    content_tag(:strong, name, class: 'comment-author')
  end
end
