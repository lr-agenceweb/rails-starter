require 'test_helper'

#
# == About model test
#
class AboutTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should have correct user for article' do
    assert_equal 'anthony', @about.user_username
  end

  private

  def initialize_test
    @about = posts(:about)
  end
end
