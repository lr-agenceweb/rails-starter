require 'test_helper'

#
# == MenuHelper Test
#
class MenuHelperTest < ActionView::TestCase
  include MenuHelper

  setup :initialize_test

  test 'should return active class for home page' do
    assert_equal set_active_class('homes', 'index'), 'active'
  end

  test 'should not return active class if action params is show for home page' do
    assert_nil set_active_class('homes', 'show')
  end

  test 'should return active class if action params is false for home page' do
    assert_equal set_active_class('homes'), 'active'
  end

  test 'should not return active class for contact page' do
    assert_nil set_active_class('contacts', 'new')
  end

  test 'should not return active class if action params is false for contact page' do
    assert_nil set_active_class('contacts')
  end

  private

  def initialize_test
    params[:controller] = 'homes'
    params[:action] = 'index'
  end
end
