# frozen_string_literal: true
require 'paperclip/media_type_spoof_detector'

Paperclip.options[:content_type_mappings] = {
  srt: 'text/plain',
  vtt: 'text/plain'
}

module Paperclip
  #
  # == MediaTypeSpoofDetector
  #
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
