# frozen_string_literal: true
require 'test_helper'

#
# StringBox Model test
# ======================
class StringBoxTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:optional_module)
end
