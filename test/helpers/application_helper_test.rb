require 'test_helper'

#
# == ApplicationHelper Test
#
class ApplicationHelperTest < ActionView::TestCase
  test 'should return current year' do
    assert_equal current_year, Time.zone.now.year
  end
end
