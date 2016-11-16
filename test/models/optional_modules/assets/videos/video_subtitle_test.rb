# frozen_string_literal: true
require 'test_helper'

#
# VideoSubtitle Model test
# ==========================
class VideoSubtitleTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:subtitleable)

  should have_attached_file(:subtitle_fr)
  should_not validate_attachment_presence(:subtitle_fr)

  should have_attached_file(:subtitle_en)
  should_not validate_attachment_presence(:subtitle_en)
end
