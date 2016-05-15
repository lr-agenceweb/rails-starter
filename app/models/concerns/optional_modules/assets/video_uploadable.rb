# frozen_string_literal: true

#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Module Assets
  #
  module Assets
    #
    # == VideoUploadable Concerns
    #
    module VideoUploadable
      extend ActiveSupport::Concern

      included do
        include OptionalModules::Assets::VideoNotifiable

        has_many :video_uploads, -> { order(:position) }, as: :videoable, dependent: :destroy, before_add: :video_flash_upload_in_progress
        accepts_nested_attributes_for :video_uploads, reject_if: proc { |attributes| attributes['video_file'].blank? }, allow_destroy: true

        has_one :video_upload, as: :videoable, dependent: :destroy
        accepts_nested_attributes_for :video_upload, reject_if: proc { |attributes| attributes['video_file'].blank? }, allow_destroy: true

        delegate :online, to: :video_upload, prefix: true, allow_nil: true
        delegate :online, to: :video_uploads, prefix: true, allow_nil: true
      end
    end
  end
end
