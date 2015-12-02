#
# == LegalNotices Controller
#
class LegalNoticesController < ApplicationController
  decorates_assigned :legal_notices

  def index
    @legal_notices = LegalNotice.includes(:translations).online
    seo_tag_index category
  end
end
