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
    # == Audioable Concerns
    #
    module Audioable
      extend ActiveSupport::Concern

      included do
        attr_accessor :flash_notice

        has_many :audios, as: :audioable, dependent: :destroy
        accepts_nested_attributes_for :audios, reject_if: :all_blank, allow_destroy: true

        delegate :online, to: :audios, prefix: true, allow_nil: true

        def flash_upload_in_progress(*)
          self.flash_notice = I18n.t('audio.flash.upload_in_progress')
        end

        def audios?
          audios.first.present?
        end
      end
    end
  end
end
