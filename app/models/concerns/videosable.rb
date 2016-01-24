#
# == Videosable Concerns
#
module Videosable
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    attr_accessor :flash_notice

    has_many :video_platforms, -> { order(:position) }, as: :videoable, dependent: :destroy
    accepts_nested_attributes_for :video_platforms, reject_if: :all_blank, allow_destroy: true

    has_many :video_uploads, -> { order(:position) }, as: :videoable, dependent: :destroy, before_add: :flash_upload_in_progress
    accepts_nested_attributes_for :video_uploads, reject_if: :all_blank, allow_destroy: true

    delegate :online, to: :video_platforms, prefix: true, allow_nil: true
    delegate :online, to: :video_uploads, prefix: true, allow_nil: true

    def flash_upload_in_progress(*)
      self.flash_notice = I18n.t('video_upload.flash.upload_in_progress')
    end
  end
end
