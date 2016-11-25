# frozen_string_literal: true

#
# Core namespace
# ================
module Core
  #
  # PageHelper
  # ============
  module PageHelper
    #
    # Page title
    # =============
    def title_for_page(page, opts = {})
      extra_title = defined?(opts[:extra]) ? opts[:extra] : ''
      html = []
      html << page.menu_title
      html << content_tag(:span, extra_title, class: 'page__header__title__extra') unless extra_title.blank?

      html = content_tag(:h2, nil, class: 'page__header__title', id: page.name.downcase) do
        concat link_to(safe_join([html]), resource_route_index(page.name), class: 'page__header__title__link')
      end

      safe_join [html]
    end

    #
    # Page Background
    # =================
    def background_from_color_picker(page)
      "background-color: #{page.color}" unless page.nil? || page.color.blank?
    end

    #
    # Pages actions
    # ================
    def index_page?
      params[:action] == 'index' || (params[:controller] == 'blog_categories' && params[:action] == 'show')
    end

    def show_page?
      params[:action] == 'show' && params[:controller] != 'blog_categories'
    end

    #
    # Page or article URL
    # ======================
    def resource_route_index(resource_name, absolute = false)
      suffix = absolute ? 'url' : 'path'
      return send("root_#{suffix}") if resource_name == 'Home'
      send("#{resource_name.underscore.pluralize}_#{suffix}")
    end

    def resource_route_show(resource, absolute = false)
      suffix = absolute ? 'url' : 'path'
      resource_name = resource.class.to_s
      return send("root_#{suffix}") if resource_name == 'Home'
      return send("legal_notices_#{suffix}") if resource_name == 'LegalNotice'
      return send("connections_#{suffix}") if resource_name == 'Connection'
      return send("blog_category_blog_#{suffix}", resource.blog_category, resource) if resource_name == 'Blog'
      send("#{resource_name.underscore.singularize}_#{suffix}", resource)
    end
  end
end
