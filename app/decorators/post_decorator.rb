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
    content_tag(:div, nil, class: 'author-with-avatar') do
      concat(raw("#{author_avatar} <br /> #{link_author}"))
    end
  end

  def allow_comments_status
    color = model.allow_comments? ? 'green' : 'red'
    status_tag_deco I18n.t("allow_comments.#{model.allow_comments}"), color
  end

  #
  # == Picture
  #
  def image
    if pictures?
      retina_image_tag first_pictures, :image, :small
    else
      'Pas d\'image'
    end
  end

  def image_has_many_by_size(size)
    retina_image_tag first_pictures, :image, size, data: interchange_has_many if pictures?
  end

  def image_has_one_by_size(size)
    retina_image_tag picture, :image, size, data: interchange_has_one if picture?
  end

  def background_picture_cover_has_one
    content_tag(:div, '', class: 'background', style: "background-image: url(#{model.image_url_by_size(:large)})", data: { interchange: "[#{model.image_url_by_size(:large)}, (default)], [#{model.image_url_by_size(:medium)}, (small)], [#{model.image_url_by_size(:medium)}, (medium)], [#{model.image_url_by_size(:large)}, (large)]" })
  end

  def background_picture_cover_has_many
    content_tag(:div, '', class: 'background', style: "background-image: url(#{model.first_picture_image_url_by_size(:large)})", data: { interchange: "[#{model.first_picture_image_url_by_size(:large)}, (default)], [#{model.first_picture_image_url_by_size(:medium)}, (small)], [#{model.first_picture_image_url_by_size(:medium)}, (medium)], [#{model.first_picture_image_url_by_size(:large)}, (large)]" })
  end

  # Generate img tag and backgroud version of image for has_one relation
  def handle_has_one_picture_and_background(link = false, size = :large)
    return unless model.picture?
    img_version = content_tag(:div, class: 'hide show-for-print') do
      concat(image_has_one_by_size(size))
    end

    bg_version = content_tag(:div, class: 'background-wrapper') do
      concat(background_picture_cover_has_one)
    end

    if link
      link_version = content_tag(:a, href: model.image_url_by_size(size), class: 'magnific-popup background-wrapper-link') do
        concat(bg_version)
      end

      return img_version + link_version
    end

    img_version + bg_version
  end

  # Generate img tag and backgroud version of image for has_many relation
  def handle_has_many_picture_and_background(_link = false, size = :large)
    content_tag(:div, class: 'hide show-for-print') do
      concat(image_has_many_by_size(size))
    end if model.pictures?
    content_tag(:div, class: 'background-wrapper') do
      concat(background_picture_cover_has_many)
    end if model.pictures?
  end

  # Method used to display content in RSS Feed
  def image_and_content
    html = content
    html << image_tag(attachment_url(first_pictures.image, :medium)) if pictures?
    html
  end

  def loop_hover_has_many_pictures(link = false, size = :large)
    content_tag(:div, '', class: 'pictures') do
      model.pictures_online.each do |picture|
        concat(content_tag(:div) do
          img_version = picture.decorate.self_image_has_one_by_size(size)
          concat(link_to img_version, picture.decorate.self_image_url_by_size(:large), title: picture.title, class: 'magnific-popup') if link
          concat(img_version) unless link
        end)
      end
    end if model.pictures?
  end

  #
  # == Post
  #
  def content
    model.content.html_safe if content?
  end

  def title_front_link
    if model.type == 'Home'
      link = root_path
    elsif model.type == 'LegalNotice'
      link = legal_notices_path
    else
      link = send("#{model.type.singularize.underscore.downcase}_path", model)
    end
    link_to raw(model.title), link, target: :_blank
  end

  def admin_link
    link = send("admin_#{model.type.singularize.underscore.downcase}_path", model)
    link_to I18n.t('active_admin.show'), link
  end

  #
  # Type of Post
  #
  def type_title
    Category.title_by_category(type)
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    I18n.t('post.title_aa_show', page: type_title)
  end

  #
  # Microdatas
  #
  def microdata_meta
    content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/Article') do
      concat(tag(:meta, itemprop: 'name headline', content: model.title))
      concat(tag(:meta, itemprop: 'text', content: model.content)) if content?
      concat(tag(:meta, itemprop: 'url', content: show_page_link(true)))
      concat(tag(:meta, itemprop: 'creator', content: model.user_username))
      concat(tag(:meta, itemprop: 'datePublished', content: model.created_at.to_datetime))
      concat(tag(:meta, itemprop: 'image', content: attachment_url(model.first_pictures_image, :medium))) if model.pictures?
    end
  end

  private

  def interchange_has_one
    { interchange: "[#{model.image_url_by_size(:large)}, (default)], [#{model.image_url_by_size(:small)}, (small)], [#{model.image_url_by_size(:medium)}, (medium)], [#{model.image_url_by_size(:large)}, (large)]" }
  end

  def interchange_has_many
    { interchange: "[#{model.first_picture_image_url_by_size(:large)}, (default)], [#{model.first_picture_image_url_by_size(:small)}, (small)], [#{model.first_picture_image_url_by_size(:medium)}, (medium)], [#{model.first_picture_image_url_by_size(:large)}, (large)]" }
  end
end
