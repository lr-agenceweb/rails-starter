# frozen_string_literal: true
require 'test_helper'

#
# VideoPlatform Model test
# ==========================
class VideoPlatformTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:videoable)
  should validate_presence_of(:url)

  should allow_value('http://test.com').for(:url)
  should_not allow_value('http://test').for(:url)
end
