#
# == PostDecorator
#
class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  def image
    if picture?
      retina_image_tag first_picture, :image, :small
    else
      'Pas d\'image'
    end
  end

  def content
    model.content.html_safe
  end

  def online
    arbre do
      status_tag("#{model.online}", (model.online? ? :ok : :warn))
    end
  end

  # Method used to display content in RSS Feed
  def image_and_content
    html = content
    html << image_tag(attachment_url(first_picture.image, :medium)) if picture?
    html
  end

  def title_front_link
    link = root_path
    link = send("#{model.type.downcase.underscore.singularize}_path", model) unless model.type == 'Home'
    link_to model.title, link, target: :_blank
  end

  def admin_link
    link = send("admin_#{model.type.downcase.underscore.singularize}_path", model)
    link_to I18n.t('active_admin.show'), link
  end

  # Type of Post
  #
  #
  def type_title
    Category.title_by_category(type)
  end

  private

  def first_picture
    model.pictures.online.first if picture?
  end

  def picture?
    model.pictures.online.present?
  end
end
