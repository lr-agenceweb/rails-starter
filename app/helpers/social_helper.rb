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
    title_seo = "#{category.title} - #{@setting.title_and_subtitle}"
    set_meta_tags title: title_seo,
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
  #   - +current_object+ -> object for which we want informations
  #
  def seo_tag_show(current_object)
    img = image_for_object(current_object)
    title_seo = "#{current_object.title} - #{@setting.title_and_subtitle}"
    url = current_object.decorate.show_page_link(true)

    set_meta_tags title: title_seo,
                  description: sanitize_and_truncate(current_object.referencement_description),
                  keywords: current_object.referencement_keywords,
                  og: {
                    type:  'article',
                    title: title_seo,
                    description: sanitize_and_truncate(current_object.referencement_description),
                    url:   url,
                    image: img
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: Figaro.env.twitter_username,
                    creator: Figaro.env.twitter_username,
                    title: title_seo,
                    description: sanitize_and_truncate(current_object.referencement_description),
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
    element = params[:action] == 'index' || params[:action] == 'new' ? @category : @element
    title_seo = "#{element.title} - #{@setting.title_and_subtitle}"

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
end
