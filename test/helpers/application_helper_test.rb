# frozen_string_literal: true
require 'test_helper'

#
# == ApplicationHelper Test
#
class ApplicationHelperTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Pages actions
  #
  test 'should return correct value for index_page?' do
    params[:action] = 'index'
    assert index_page?
    params[:action] = 'new'
    assert_not index_page?

    params[:controller] = 'blog_categories'
    params[:action] = 'show'
    assert index_page?
  end

  test 'should return correct value for show_page?' do
    params[:action] = 'new'
    assert_not show_page?
    params[:action] = 'show'
    assert show_page?

    params[:controller] = 'blog_categories'
    params[:action] = 'show'
    assert_not show_page?
  end

  #
  # == DateTime
  #
  test 'should return current year' do
    assert_equal Time.zone.now.year, current_year
  end

  #
  # == Maintenance
  #
  test 'should return true if maintenance is enabled' do
    @setting.update_attributes(maintenance: true)
    assert maintenance?(@request), 'should be in maintenance'
  end

  test 'should return false if maintenance is disabled' do
    assert_not maintenance?(@request), 'should not be in maintenance'
  end

  #
  # == Git
  #
  test 'should return correct branch name by environment' do
    Rails.env = 'staging'
    assert_equal 'BranchName', branch_name
    Rails.env = 'development'
    assert_equal `git rev-parse --abbrev-ref HEAD`, branch_name
    Rails.env = 'test'
  end

  private

  def initialize_test
    @setting = settings(:one)
  end
end
