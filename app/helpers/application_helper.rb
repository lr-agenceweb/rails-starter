# frozen_string_literal: true

#
# == ApplicationHelper
#
module ApplicationHelper
  def current_year
    Time.zone.now.year
  end

  def title_for_category(category, opts = {})
    extra_title = defined?(opts[:title]) ? opts[:title] : ''
    page_title = category.menu_title
    page_title << " <span class='extra-title'>#{extra_title}</span>" unless extra_title.blank?
    link = link_to raw(page_title), category.menu_link(category.name), class: 'page-title-link'
    content_tag(:h2, link, class: 'page-title', id: category.name.downcase)
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

  #
  # == Maintenance
  #
  def maintenance?(req = request)
    @setting.maintenance? && (!req.path.include?('/admin') || !self.class.name.to_s.split('::').first == 'ActiveAdmin')
  end
end
