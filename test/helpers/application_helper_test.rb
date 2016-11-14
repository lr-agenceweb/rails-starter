# frozen_string_literal: true
require 'test_helper'

#
# ApplicationHelper Test
# ========================
class ApplicationHelperTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # Page title
  # =============
  test 'should return correct formatted page title' do
    expected = '<h2 class="page__header__title" id="contact"><a class="page__header__title__link" href="/contact">Contact</a></h2>'
    assert_equal expected, title_for_page(@contact.decorate)
  end

  test 'should return correct formatted page title with extra title' do
    opts = { extra: 'Lorem Ipsum' }
    expected = '<h2 class="page__header__title" id="contact"><a class="page__header__title__link" href="/contact">Contact<span class="page__header__title__extra">Lorem Ipsum</span></a></h2>'
    assert_equal expected, title_for_page(@contact.decorate, opts)
  end

  #
  # Page Background
  # =================
  test 'should return correct background color for page' do
    # Without background color
    assert_nil background_from_color_picker(@contact)

    # With background color
    @contact.update_attribute(:color, '#000')
    expected = 'background-color: #000'
    assert_equal expected, background_from_color_picker(@contact)
  end

  #
  # Pages actions
  # ================
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
  # DateTime
  # ==========
  test 'should return current year' do
    assert_equal Time.zone.now.year, current_year
  end

  #
  # Maintenance
  # =============
  test 'should return true if maintenance is enabled' do
    @setting.update_attributes(maintenance: true)
    assert maintenance?(@request), 'should be in maintenance'
  end

  test 'should return false if maintenance is disabled' do
    assert_not maintenance?(@request), 'should not be in maintenance'
  end

  #
  # Git
  # =============
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
    @contact = pages(:contact)
  end
end
