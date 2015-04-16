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
  def awesome_social_share
    element = params[:action] == 'index' || params[:action] == 'new' ? @category : instance_variable_get("@#{controller_name.underscore.singularize}")
    title_seo = title_seo_structure(element.title)

    awesome_share_buttons(title_seo,
                          desc: element.referencement_description,
                          image: image_for_object(element),
                          via: Figaro.env.twitter_username,
                          popup: true)
  end

  private

  # Get image for an object
  #
  # * *Args*    :
  #   - +object+ -> object to get image
  # * *Returns* :
  #   - the image for a given object if any
  #
  def image_for_object(obj)
    defined?(obj.picture) && !obj.picture.nil? ? attachment_url(obj.picture.image, :large) : nil
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
