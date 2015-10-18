#
# == AssetsHelper
#

# This file contain helpfull assets methods
# - images
#
module AssetsHelper
  # Helper that add the retina version for the images except for svg
  def image_tag_with_at2x(image, size, options = {})
    if image
      name_at_2x = image.url((size.to_s + '_2x').to_sym)
      image_tag(image.url(size), options.merge('data-at2x' => asset_path(name_at_2x)))
    else
      image_tag('/assets/images/default_media/' + size.to_s + '-missing.png', options)
    end
  end

  def attachment_url(file, style = :original, req = request)
    if file.nil?
      URI.join(req.url, "/default/#{style}-missing.png").to_s
    else
      URI.join(req.url, file.url(style)).to_s
    end
  end

  def retina_thumb_square(resource, size = 64)
    if resource.avatar?
      retina_image_tag(resource, :avatar, :thumb, default: [size, size])
    else
      gravatar_image_tag(resource.email, alt: resource.username, gravatar: { size: size })
    end
  end

  def retina_large_square(resource, size = 256)
    retina_thumb_square resource, size
  end

  #
  # == Videos
  #
  def show_video_background?(video_settings, video_module)
    video_settings.video_upload? && video_settings.video_background? && video_module.enabled?
  end
end
