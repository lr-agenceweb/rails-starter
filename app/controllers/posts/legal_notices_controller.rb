# frozen_string_literal: true

#
# == LegalNotices Controller
#
class LegalNoticesController < ApplicationController
  decorates_assigned :legal_notices

  def index
    @legal_notices = LegalNotice.includes(:translations).online.by_position
    seo_tag_index category
  end
end
