require 'test_helper'

class OptionalModuleTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return list of optional modules name in string' do
    assert_includes OptionalModule.list, 'Newsletter'
    assert_includes OptionalModule.list, 'GuestBook'
    assert_includes OptionalModule.list, 'Search'
    assert_includes OptionalModule.list, 'RSS'
    assert_includes OptionalModule.list, 'Comment'
    assert_includes OptionalModule.list, 'Blog'
    assert_includes OptionalModule.list, 'Adult'
    assert_includes OptionalModule.list, 'Slider'
    assert_includes OptionalModule.list, 'Event'
    assert_includes OptionalModule.list, 'Map'
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
