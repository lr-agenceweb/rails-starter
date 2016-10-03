# frozen_string_literal: true

#
# == LegalNotices Controller
#
class LegalNoticesController < ApplicationController
  decorates_assigned :legal_notices

  def index
    @legal_notices = LegalNotice.includes(:translations, :video_uploads, :video_platforms, :picture, :user).online.by_position
    seo_tag_index category
  end
end
