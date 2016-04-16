# frozen_string_literal: true
#
# == AssetsHelper
#
module AssetsHelper
  def attachment_url(file, style = :original, req = request)
    if file.nil?
      URI.join(req.url, "/default/#{style}-missing.png").to_s
    else
      URI.join(req.url, file.url(style)).to_s
    end
  end

  def process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, allow_redirections: :safe) do |r|
      r.base_uri.to_s
    end
  end

  #
  # == Pictures
  #
  def retina_thumb_square(resource, size = 64)
    if resource.avatar?
      retina_image_tag(resource, :avatar, :small, default: [size, size])
    else
      gravatar_image_tag(resource.email, alt: resource.username, gravatar: { size: size, secure: true })
    end
  end

  #
  # == Videos
  #
  def show_video_background?(video_settings, video_module)
    video_settings.video_upload? && video_settings.video_background? && video_module.enabled?
  end
end
