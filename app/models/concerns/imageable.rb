#
# == Imageable Concerns
#
module Imageable
  extend ActiveSupport::Concern
  include ApplicationHelper

  def picture?
    picture.present? && picture.online
  end

  def picture_medium
    picture.image.url(:medium) if picture?
  end
end
