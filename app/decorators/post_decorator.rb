# frozen_string_literal: true

#
# PostDecorator
# ===============
class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :user
  decorates_association :pictures

  #
  # Author and avatar linked to Post
  # ==================================
  def author
    model.user_username
  end

  def link_author
    link_to author, admin_user_path(model.user)
  end

  def author_avatar
    safe_join [user.image_avatar.html_safe]
  end

  def author_with_avatar
    author_with_avatar_html(author_avatar, link_author)
  end

  #
  # Picture
  # =========
  def image
    pictures? ? retina_image_tag(first_pictures, :image, :small) : t('post.no_cover')
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
    html << image_tag(asset_url(first_pictures.image.url(:medium))) if pictures?
    html
  end

  #
  # Post
  # ======
  def title_front_link
    link_to title, resource_route_show(model), target: :_blank
  end

  def admin_link
    link = send("admin_#{model.class.name.underscore}_path", model)
    link_to I18n.t('active_admin.show'), link
  end

  #
  # Type of Post
  # ==============
  def type_title
    Page.title_by_page(type)
  end

  #
  # ActiveAdmin
  # =============
  def title_aa_show
    I18n.t('post.title_aa_show', page: type_title, title: title)
  end

  #
  # Comments
  # ==========
  def comments_count
    comments.validated.count
  end

  #
  # PublicationDate (publishable polymorphic)
  # ===========================================
  # TODO: Refactor duplicated code
  def publication
    html = []
    html << add_bool_value
    html << content_tag(:p, safe_join([raw("#{t('activerecord.attributes.publication_date.published_at')}: #{l(model.published_at, format: :without_time)}")])) if model.published_at && model.published_later?
    html << content_tag(:p, safe_join([raw("#{t('activerecord.attributes.publication_date.expired_at')}: #{l(model.expired_at, format: :without_time)}")])) if model.expired_at && model.expired_prematurely?
    safe_join [html]
  end

  def published_at
    l(model.published_at, format: :without_time) if model.published_later?
  end

  def expired_at
    l(model.expired_at, format: :without_time) if model.expired_prematurely?
  end

  #
  # Link (linkable polymorphic)
  # =============================
  def link?
    model.link.try(:url).present?
  end

  def link_with_link
    link_to model.link_url, model.link_url, target: :_blank if link?
  end

  #
  # Post link (regular Post or Blog)
  # ==================================
  def show_post_link(suffix = 'path')
    model.is_a?(Blog) ? send("blog_category_blog_#{suffix}", model.blog_category, model) : send("#{model.class.name.underscore}_#{suffix}", model)
  end

  private

  def add_bool_value
    content_tag(:p) do
      if published?
        concat(content_tag(:span, '✔', class: 'bool-value true-value'))
        concat(content_tag(:span, t('activerecord.attributes.publication_date.published')))
      else
        concat(content_tag(:span, '✗', class: 'bool-value false-value'))
        concat(content_tag(:span, t('activerecord.attributes.publication_date.unpublished')))
      end
    end
  end
end
