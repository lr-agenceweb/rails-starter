#
# == BlogDecorator
#
class BlogDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # Microdatas
  #
  def microdata_meta
    content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/BlogPosting') do
      concat(tag(:meta, itemprop: 'headline', content: model.title))
      concat(tag(:meta, itemprop: 'articleBody', content: model.content)) if content?
      concat(tag(:meta, itemprop: 'url', content: show_page_link(true)))
      concat(tag(:meta, itemprop: 'creator', content: model.user_username))
      concat(tag(:meta, itemprop: 'datePublished', content: model.created_at.to_datetime))
      concat(tag(:meta, itemprop: 'image', content: attachment_url(model.first_pictures_image, :medium))) if model.pictures?
    end
  end
end
