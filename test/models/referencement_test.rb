# frozen_string_literal: true
require 'test_helper'

#
# Referencement Model test
# ==========================
class ReferencementTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:attachable)
end
