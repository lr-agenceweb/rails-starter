#
# == PostDecorator
#
class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def image_and_content
    # return "#{picture_medium} #{content}" unless model.picture.exist?
    content
  end
end
