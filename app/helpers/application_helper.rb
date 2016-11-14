# frozen_string_literal: true

#
# == ApplicationHelper
#
module ApplicationHelper
  def current_year
    Time.zone.now.year
  end

  # TESTME
  def title_for_page(page, opts = {})
    extra_title = defined?(opts[:extra]) ? opts[:extra] : ''
    html = []
    html << page.menu_title
    html << content_tag(:span, extra_title, class: 'page__header__title__extra') unless extra_title.blank?

    html = content_tag(:h2, nil, class: 'page__header__title', id: page.name.downcase) do
      concat link_to(safe_join([html]), page.menu_link(page.name), class: 'page__header__title__link')
    end

    safe_join [html]
  end

  # TESTME
  def background_from_color_picker(page)
    "background-color: #{page.color}" unless page.nil? || page.color.blank?
  end

  #
  # == Pages actions
  #
  def index_page?
    params[:action] == 'index' || (params[:controller] == 'blog_categories' && params[:action] == 'show')
  end

  def show_page?
    params[:action] == 'show' && params[:controller] != 'blog_categories'
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

  #
  # == Git
  #
  def branch_name
    Rails.env.staging? ? 'BranchName' : `git rev-parse --abbrev-ref HEAD`
  end
end
