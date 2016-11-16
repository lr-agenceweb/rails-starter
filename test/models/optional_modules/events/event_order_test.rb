# frozen_string_literal: true
require 'test_helper'

#
# EventOrder Model test
# =======================
class EventOrderTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should have_one(:event_setting)
end
