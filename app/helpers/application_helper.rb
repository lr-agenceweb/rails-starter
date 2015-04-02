#
# == ApplicationHelper
#
module ApplicationHelper
  include AssetsHelper
  include TruncateHtmlHelper

  def current_user_and_administrator?
    true if current_user # && current_user.is_administrator?
  end

  def current_year
    Time.zone.now.year
  end

  def sanitize_string(string)
    ActionView::Base.full_sanitizer.sanitize(string)
  end

  def sanitize_and_truncate(string, length = 160)
    truncate_html(sanitize_string(string), length: length, separator: '.', escape: true)
  end

  def seo_tag_index(category, background = nil)
    img = background.nil? ? '' : attachment_url(background.image, :medium)
    set_meta_tags title: category.title,
                  description: sanitize_and_truncate(category.referencement_description),
                  keywords: category.referencement_keywords,
                  og: {
                    title: category.title,
                    description: sanitize_and_truncate(category.referencement_description),
                    type: 'article',
                    url: category.menu_link(category.name, true),
                    image: img
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: Figaro.env.twitter_username,
                    creator: Figaro.env.twitter_username,
                    title: category.title,
                    description: sanitize_and_truncate(category.referencement_description),
                    url: category.menu_link(category.name, true),
                    image: img
                  }
  end

  # def seo_tag_show(current_object, url)
  #   img = image_for_event(current_object)
  #   title = current_object.decorate.title_for_shareable
  #   set_meta_tags title: title,
  #                 description: sanitize_and_truncate(current_object.excerpt),
  #                 keywords: current_object.keywords,
  #                 og: {
  #                   type:  'article',
  #                   title: title,
  #                   description: sanitize_and_truncate(current_object.excerpt),
  #                   url:   url,
  #                   image: img
  #                 },
  #                 twitter: {
  #                   card: 'summary_large_image',
  #                   site: Figaro.env.twitter_username,
  #                   creator: Figaro.env.twitter_username,
  #                   title: title,
  #                   description: sanitize_and_truncate(current_object.excerpt),
  #                   url:   url,
  #                   image: img
  #                 }
  # end
end
