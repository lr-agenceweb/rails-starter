#
# == SocialHelper
#
module SocialHelper
  include AssetsHelper

  def seo_tag_index(category, background = nil)
    img = background.nil? ? nil : attachment_url(background.image, :medium)
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

  def seo_tag_show(current_object)
    img = image_for_object(current_object)
    title = current_object.title
    url = current_object.decorate.show_page_link(true)

    set_meta_tags title: title,
                  description: sanitize_and_truncate(current_object.referencement_description),
                  keywords: current_object.referencement_keywords,
                  og: {
                    type:  'article',
                    title: title,
                    description: sanitize_and_truncate(current_object.referencement_description),
                    url:   url,
                    image: img
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: Figaro.env.twitter_username,
                    creator: Figaro.env.twitter_username,
                    title: title,
                    description: sanitize_and_truncate(current_object.referencement_description),
                    url:   url,
                    image: img
                  }
  end

  def awesome_social_share
    if params[:action] == 'index' || params[:action] == 'new'
      awesome_share_buttons(@category.title,
                            desc: @category.referencement_description,
                            image: image_for_object(@category),
                            via: Figaro.env.twitter_username,
                            popup: true)
    else
      awesome_share_buttons(@element.title,
                            desc: @element.referencement_description,
                            image: image_for_object(@element),
                            via: Figaro.env.twitter_username,
                            popup: true)
    end
  end

  private

  def image_for_object(obj)
    image = nil
    image = attachment_url(obj.picture.image, :large) if defined?(obj.picture) && !obj.picture.nil?
    image
  end
end
