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
    URI.join(req.url, file.url(style)).to_s unless file.nil?
  end

  def retina_thumb_square(resource)
    retina_image_tag(resource, :avatar, :thumb, default: [64, 64])
  end
end
