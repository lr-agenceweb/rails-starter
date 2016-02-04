#
# == LegalNotices Controller
#
class LegalNoticesController < ApplicationController
  decorates_assigned :legal_notices

  def index
    @legal_notices = LegalNotice.includes(:user, :picture, :translations, :video_uploads, :video_platforms).online.by_position
    seo_tag_index category
  end
end
