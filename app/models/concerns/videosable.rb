#
# == Videosable Concerns
#
module Videosable
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    has_many :videos, -> { order(:position) }, as: :videoable, dependent: :destroy
    accepts_nested_attributes_for :videos, reject_if: :all_blank, allow_destroy: true

    has_many :video_uploads, -> { order(:position) }, as: :videoable, dependent: :destroy
    accepts_nested_attributes_for :video_uploads, reject_if: :all_blank, allow_destroy: true

    delegate :online, to: :videos, prefix: true, allow_nil: true
    delegate :online, to: :video_uploads, prefix: true, allow_nil: true
  end
end
