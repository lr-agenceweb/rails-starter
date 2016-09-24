# frozen_string_literal: true

#
# == PostDecorator
#
class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :user
  decorates_association :pictures

  #
  # == Author and avatar linked to Post
  #
  def author
    model.user_username
  end

  def link_author
    link_to author, admin_user_path(model.user)
  end

  def author_avatar
    user.image_avatar.html_safe
  end

  def author_with_avatar
    author_with_avatar_html(author_avatar, link_author)
  end

  #
  # == Picture
  #
  def image
    pictures? ? retina_image_tag(first_pictures, :image, :small) : 'Pas d\'image'
  end

  def custom_cover
    if model.pictures?
      retina_image_tag(first_pictures, :image, :medium)
    elsif model.video_uploads?
      retina_image_tag(model.video_upload, :video_file, :preview)
    elsif model.video_platforms?
      model.video_platform.decorate.preview
    end
  end

  # Method used to display content in RSS Feed
  def image_and_content
    html = content
    html << image_tag(attachment_url(first_pictures.image, :medium)) if pictures?
    html
  end

  #
  # == Post
  #
  def content
    model.content.html_safe if content?
  end

  def title_front_link
    link_to raw(model.title), show_page_link, target: :_blank
  end

  def admin_link
    link = send("admin_#{model.type.singularize.underscore.downcase}_path", model)
    link_to I18n.t('active_admin.show'), link
  end

  #
  # == Type of Post
  #
  def type_title
    Category.title_by_category(type)
  end

  #
  # == ActiveAdmin
  #
  def title_aa_show
    I18n.t('post.title_aa_show', page: type_title)
  end

  #
  # == Comments
  #
  def comments_count
    comments.validated.count
  end

  #
  # == PublicationDate (publishable polymorphic)
  #
  def publication
    return '/' unless model.published_later? || model.expired_prematurely?
    html = ''
    html += content_tag(:p, "#{t('activerecord.attributes.publication_date.published_at')}: #{l(model.published_at, format: :without_time)}") if model.published_later?
    html += content_tag(:p, "#{t('activerecord.attributes.publication_date.expirexpired_at')}: #{l(model.expired_at, format: :without_time)}") if model.expired_prematurely?
    html.html_safe
  end

  def published_at
    l(model.published_at, format: :without_time) if model.published_later?
  end

  def expired_at
    l(model.expired_at, format: :without_time) if model.expired_prematurely?
  end

  #
  # == Link (linkable polymorphic)
  #
  def link_with_link
    link_to model.link.url, model.link.url, target: :_blank if link?
  end

  private

  def link?
    model.link.try(:url).present?
  end
end
