# frozen_string_literal: true
#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == SocialHelper
  #
  module SocialHelper
    include AssetsHelper
    include ERB::Util

    # SEO Meta tags for index pages (include Facebook and Twitter)
    #
    # * *Args*    :
    #   - +category+ -> category corresponding to the page
    #   - +background+ -> background picture for category
    #
    def seo_tag_index(category, background = nil)
      return false if category.nil?
      img = background.nil? ? nil : attachment_url(background.image, :medium)
      title_seo = title_seo_structure(category.menu_title)
      set_meta_tags title: category.menu_title,
                    description: sanitize_and_truncate(category.referencement_description),
                    keywords: category.referencement_keywords,
                    og: {
                      title: title_seo,
                      description: sanitize_and_truncate(category.referencement_description),
                      type: 'article',
                      url: category.menu_link(category.name, true),
                      image: img
                    },
                    twitter: {
                      card: 'summary_large_image',
                      site: Figaro.env.twitter_username,
                      creator: Figaro.env.twitter_username,
                      title: title_seo,
                      description: sanitize_and_truncate(category.referencement_description),
                      url: category.menu_link(category.name, true),
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
      url = element.decorate.show_page_link(true)
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
      html << "<div class='awesome-share-buttons' data-title='#{h title}' data-img='#{opts[:image]}' "
      html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-popup='#{opts[:popup]}' data-via='#{opts[:via]}'>"

      @socials_share.each do |social|
        link_title = t 'awesome_share_buttons.share_to', name: t("awesome_share_buttons.#{social.title.downcase}")
        ikon = social.title
        ikon = fa_icon social.font_ikon if social.decorate.font_ikon?
        ikon = retina_image_tag(social, :ikon, :small) if social.decorate.ikon?

        html << link_to(ikon, '#',
                        rel: ['nofollow', rel],
                        'data-site': social.title.downcase,
                        onclick: 'return SocialShareClass.share(this);',
                        title: h(link_title))
      end
      html << '</div>'
      raw html.join("\n")
    end

    # Get image for an object
    #
    # * *Args*    :
    #   - +object+ -> object to get image
    # * *Returns* :
    #   - the image for a given object if any
    #
    def image_for_object(obj)
      return attachment_url(obj.picture.image, :large) if defined?(obj.picture) && obj.picture?
      return attachment_url(obj.first_pictures_image, :large) if defined?(obj.pictures) && obj.pictures?
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
      "#{element_title} | #{@setting.title_and_subtitle}"
    end

    def return_nil_for_social_share?
      params[:controller] == 'comments' || params[:controller] == 'errors'
    end

    def element_by_action
      params[:action] == 'index' || params[:action] == 'new' || params[:action] == 'create' || params[:action] == 'autocomplete' || (params[:controller] == 'blog_categories' && params[:action] == 'show') ? @category : instance_variable_get("@#{controller_name.underscore.singularize}")
    end
  end
end
