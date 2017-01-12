# frozen_string_literal: true

#
# OptionalModules namespace
# ===========================
module OptionalModules
  #
  # SocialHelper
  # ==============
  module SocialHelper
    include Core::PageHelper
    include AssetsHelper
    include ERB::Util

    # SEO Meta tags for index pages (include Facebook and Twitter)
    #
    # * *Args*    :
    #   - +page+ -> page corresponding to the page
    #   - +background+ -> background picture for page
    #
    def seo_tag_index(page, background = nil)
      return false if page.nil?
      img = background.nil? ? nil : asset_url(background.image.url(:medium))
      title_seo = title_seo_structure(page.menu_title)
      set_meta_tags title: page.menu_title,
                    description: sanitize_and_truncate(page.referencement_description),
                    keywords: page.referencement_keywords,
                    og: {
                      title: title_seo,
                      description: sanitize_and_truncate(page.referencement_description),
                      type: 'article',
                      url: resource_route_index(page.name, true),
                      image: img
                    },
                    twitter: {
                      card: 'summary_large_image',
                      site: @setting.try(:twitter_username),
                      creator: @setting.try(:twitter_username),
                      title: title_seo,
                      description: sanitize_and_truncate(page.referencement_description),
                      url: resource_route_index(page.name, true),
                      image: img
                    }
    end

    # SEO Meta tags for show pages (include Facebook and Twitter)
    #
    # * *Args*    :
    #   - +element+ -> object for which we want informations
    #
    def seo_tag_show(element)
      img = image_for_object(element)
      title_seo = title_seo_structure(element.title)
      url = resource_route_show(element.object, true)
      desc = html_escape_once(sanitize_and_truncate(element.referencement_description))

      set_meta_tags title: element.title,
                    description: desc,
                    keywords: element.referencement_keywords,
                    og: {
                      type:  'article',
                      title: title_seo,
                      description: desc,
                      url:   url,
                      image: img
                    },
                    twitter: {
                      card: 'summary_large_image',
                      site: @setting.try(:twitter_username),
                      creator: @setting.try(:twitter_username),
                      title: title_seo,
                      description: desc,
                      url:   url,
                      image: img
                    }
    end

    def seo_tag_custom(title = '', description = '')
      desc_seo = html_escape_once(sanitize_and_truncate(description))

      set_meta_tags title: title,
                    description: desc_seo,
                    keywords: desc_seo.split(' ').join(',')
    end

    # Social share buttons links
    #
    # * *Args*    :
    # * *Returns* :
    #
    def social_share_buttons
      return nil if return_nil_for_social_share? || @asocial
      element = element_by_action
      return nil if element.nil?
      t = element.try(:menu_title).nil? ? element.title : element.menu_title

      awesome_share_buttons(title_seo_structure(t),
                            desc: html_escape_once(element.referencement_description),
                            image: image_for_object(element),
                            via: @setting.try(:twitter_username),
                            popup: true)
    end

    private

    def awesome_share_buttons(title = '', opts = {})
      rel = opts[:rel]
      html = []
      html << "<ul class='awesome-share-buttons' data-title='#{h title}' data-img='#{opts[:image]}' "
      html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-popup='#{opts[:popup]}' data-via='#{opts[:via]}'>"

      @socials_share.each do |social|
        link_title = t 'awesome_share_buttons.share_to', name: t("awesome_share_buttons.#{social.title.downcase}")
        ikon = social.title
        ikon = fa_icon social.font_ikon if social.decorate.font_ikon?
        ikon = retina_image_tag(social, :ikon, :small) if social.decorate.ikon?

        link = link_to(ikon, '#',
                       rel: ['nofollow', rel],
                       'data-site': social.title.downcase,
                       onclick: 'return SocialShareClass.share(this);',
                       title: h(link_title),
                       class: 'social__icon__link')
        html << content_tag(:li, link, class: 'social__icon')
      end
      html << '</ul>'
      safe_join [raw(html.join("\n"))]
    end

    # Get image for an object
    #
    # * *Args*    :
    #   - +object+ -> object to get image
    # * *Returns* :
    #   - the image for a given object if any
    #
    def image_for_object(obj)
      return asset_url(obj.picture.image.url(:large)) if defined?(obj.picture) && obj.picture?
      return asset_url(obj.first_pictures_image.url(:large)) if defined?(obj.pictures) && obj.pictures?
      nil
    end

    # SEO page title structure
    #
    # * *Args*    :
    #   - +element_title+ -> page title
    # * *Returns* :
    #   - the formatted title for SEO
    #
    def title_seo_structure(element_title)
      "#{element_title} | #{@setting.decorate.title_and_subtitle}"
    end

    def return_nil_for_social_share?
      params[:controller] == 'comments' || params[:controller] == 'errors'
    end

    def element_by_action
      index_page? || params[:action] == 'new' || params[:action] == 'create' || params[:action] == 'autocomplete' ? @page : instance_variable_get("@#{controller_name.underscore.singularize}")
    end
  end
end
