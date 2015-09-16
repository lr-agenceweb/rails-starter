#
# == ApplicationHelper
#
module ApplicationHelper
  def current_year
    Time.zone.now.year
  end

  def title_for_category(category)
    logger.debug "====== #{category.menu_title}"
    link = link_to category.menu_title, category.menu_link(category.name), class: 'l-page-title-link'
    content_tag(:h2, link, class: 'l-page-title', id: category.name.downcase)
  end

  def background_from_color_picker(category)
    "background-color: #{category.color}" unless category.nil? || category.color.blank?
  end

  #
  # == Site validation
  #
  def google_bing_site_verification
    "#{google_site_verification} #{bing_site_verification}"
  end

  def google_site_verification
    tag(:meta, name: 'google-site-verification', content: Figaro.env.google_site_verification) unless Figaro.env.google_site_verification.blank?
  end

  def bing_site_verification
    tag(:meta, name: 'msvalidate.01', content: Figaro.env.bing_site_verification) unless Figaro.env.bing_site_verification.blank?
  end
end
