# frozen_string_literal: true
require 'test_helper'

#
# Heading Model test
# ====================
class HeadingTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:headingable)
end
