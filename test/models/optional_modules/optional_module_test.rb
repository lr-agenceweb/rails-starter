require 'test_helper'

#
# == OptionalModule Model test
#
class OptionalModuleTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return list of optional modules name in string' do
    list_modules = OptionalModule.list
    assert_includes list_modules, 'Newsletter'
    assert_includes list_modules, 'GuestBook'
    assert_includes list_modules, 'Search'
    assert_includes list_modules, 'RSS'
    assert_includes list_modules, 'Comment'
    assert_includes list_modules, 'Blog'
    assert_includes list_modules, 'Adult'
    assert_includes list_modules, 'Slider'
    assert_includes list_modules, 'Event'
    assert_includes list_modules, 'Map'
    assert_includes list_modules, 'Social'
    assert_includes list_modules, 'Breadcrumb'
    assert_includes list_modules, 'Qrcode'
  end

  test 'should return correct optional module by name' do
    expected = @optional_module_event.name
    actual = OptionalModule.by_name('Event').name
    assert_equal expected, actual
  end

  private

  def initialize_test
    @optional_module_event = optional_modules(:event)
  end
end
