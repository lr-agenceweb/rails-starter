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
    # == FlashNotifiable Concerns
    #
    module FlashNotifiable
      extend ActiveSupport::Concern

      included do
        attr_accessor :video_upload_flash_notice, :audio_flash_notice
        after_commit :video_upload_flash_upload_in_progress
        after_commit :audio_flash_upload_in_progress

        private

        [VideoUpload, Audio].each do |model_object|
          mod = model_object.to_s.underscore
          define_method("#{mod}_flash_upload_in_progress") do |*|
            return unless send("self_#{mod}able?") || send("resource_#{mod}able?")
            send("#{mod}_flash_notice=", I18n.t("#{mod}.flash.upload_in_progress"))
          end

          define_method "self_#{mod}able?" do
            (is_a?(model_object) &&
              !nil? &&
              !destroyed? &&
              (model_object == VideoUpload ? video_file_processing? : audio_processing?))
          end

          define_method "resource_#{mod}able?" do
            return false if is_a?(VideoUpload) || is_a?(Audio)
            assoc = model_object.to_s.underscore.pluralize
            return false unless self.class.reflect_on_association(:"#{assoc}")
            send(assoc).each do |inst|
              return true if !inst.nil? &&
                             !inst.destroyed? &&
                             (model_object == VideoUpload ? inst.video_file_processing? : inst.audio_processing?)
            end
            false
          end
        end
      end
    end
  end
end
