#
# == SocialHelper
#
module SocialHelper
  include AssetsHelper

  # SEO Meta tags for index pages (include Facebook and Twitter)
  #
  # * *Args*    :
  #   - +category+ -> category corresponding to the page
  #   - +background+ -> background picture for category
  #
  def seo_tag_index(category, background = nil)
    return false if category.nil?
    img = background.nil? ? nil : attachment_url(background.image, :medium)
    title_seo = title_seo_structure(category.title)
    set_meta_tags title: category.title,
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

    set_meta_tags title: element.title,
                  description: sanitize_and_truncate(element.referencement_description),
                  keywords: element.referencement_keywords,
                  og: {
                    type:  'article',
                    title: title_seo,
                    description: sanitize_and_truncate(element.referencement_description),
                    url:   url,
                    image: img
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: Figaro.env.twitter_username,
                    creator: Figaro.env.twitter_username,
                    title: title_seo,
                    description: sanitize_and_truncate(element.referencement_description),
                    url:   url,
                    image: img
                  }
  end

  # Social share buttons links
  #
  # * *Args*    :
  # * *Returns* :
  #
  def social_share_buttons
    return nil if params[:controller] == 'comments'

    element = params[:action] == 'index' || params[:action] == 'new' || params[:action] == 'create' ? @category : instance_variable_get("@#{controller_name.underscore.singularize}")

    title_seo = title_seo_structure(element.title)

    awesome_share_buttons(title_seo,
                          desc: element.referencement_description,
                          image: image_for_object(element),
                          via: Figaro.env.twitter_username,
                          popup: true)
  end

  private

  def awesome_share_buttons(title = "", opts = {})
    rel = opts[:rel]
    html = []
    html << "<div class='awesome-share-buttons' data-title='#{h title}' data-img='#{opts[:image]}' "
    html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-popup='#{opts[:popup]}' data-via='#{opts[:via]}'>"

    @socials_share.each do |social|
      link_title = t 'awesome_share_buttons.share_to', name: t("awesome_share_buttons.#{social.title.downcase}")
      ikon = social.decorate.ikon? ? retina_image_tag(social, :ikon, :small) : social.title
      html << link_to(ikon, '#', {
        rel: ['nofollow', rel],
        'data-site': social.title.downcase,
        onclick: 'return SocialShareClass.share(this);',
        title: h(link_title)
      })
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
    if defined?(obj.picture) && !obj.picture.nil?
      return attachment_url(obj.picture.image, :large)
    elsif defined?(obj.pictures) && !obj.pictures.first.nil?
      return attachment_url(obj.pictures.first.image, :large)
    end
    nil
  end

  # SEO page title structure
  #
  # * *Args*    :
  #   - +element_title+ -> page title
  #   - +site_title+ -> site title
  # * *Returns* :
  #   - the formatted title for SEO
  #
  def title_seo_structure(element_title)
    "#{element_title} | #{@setting.title_and_subtitle}"
  end
end
