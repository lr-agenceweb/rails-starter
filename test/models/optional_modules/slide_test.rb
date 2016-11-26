# frozen_string_literal: true
require 'test_helper'

#
# Slide Model test
# ==================
class SlideTest < ActiveSupport::TestCase
  # Constants
  SIZE_PLUS_1 = Slide::ATTACHMENT_MAX_SIZE + 1

  #
  # Shoulda
  # =========
  should belong_to(:attachable)

  should have_attached_file(:image)
  should_not validate_attachment_presence(:image)
  should validate_attachment_content_type(:image)
    .allowing('image/jpg', 'image/png')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:image)
    .less_than((SIZE_PLUS_1 - 1).megabytes)
end
