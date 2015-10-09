#
# == VideoUploadDecorator
#
class VideoUploadDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  def preview
    h.retina_image_tag model, :video_file, :preview
  end
end
