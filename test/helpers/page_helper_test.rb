# frozen_string_literal: true
require 'test_helper'

#
# == Core namespace
#
module Core
  #
  # == PageHelper Test
  #
  class PageHelperTest < ActionView::TestCase
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # Page title
    # =============
    test 'should return correct formatted page title' do
      expected = '<h2 class="page__header__title" id="contact"><a class="page__header__title__link" href="/contact">Contact</a></h2>'
      assert_equal expected, title_for_page(@contact)
    end

    test 'should return correct formatted page title with extra title' do
      opts = { extra: 'Lorem Ipsum' }
      expected = '<h2 class="page__header__title" id="contact"><a class="page__header__title__link" href="/contact">Contact<span class="page__header__title__extra">Lorem Ipsum</span></a></h2>'
      assert_equal expected, title_for_page(@contact, opts)
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
    # Page or article URL
    # ======================
    test 'should return correct resource index route for pages' do
      assert_equal '/contact', resource_route_index('Contact')
      assert_equal 'http://test.host/contact', resource_route_index('Contact', true)
      assert_equal '/', resource_route_index('Home')
      assert_equal 'http://test.host/', resource_route_index('Home', true)
    end

    test 'should return correct resource show route for pages' do
      assert_equal blog_category_blog_path(@blog.blog_category, @blog), resource_route_show(@blog)
      assert_equal blog_category_blog_url(@blog.blog_category, @blog), resource_route_show(@blog, true)
    end

    private

    def initialize_test
      @contact = pages(:contact)
      @blog = blogs(:blog_online)
    end
  end
end
