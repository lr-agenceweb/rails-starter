require 'test_helper'

#
# == AboutsController Test
#
class AboutsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should get index' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_response :success
      assert_not_nil @about
    end
  end

  test 'should use index template' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_template :index
    end
  end

  test 'should fetch only online posts' do
    @abouts = About.online
    assert_equal @abouts.length, 2
  end

  test 'should get abouts page by url' do
    assert_routing '/a-propos', controller: 'abouts', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/about', controller: 'abouts', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Comments
  #
  test 'should get two comments for about article' do
    assert_equal @about.comments.count, 2
  end

  test 'should get alice as comments author' do
    assert_equal @comment.user_username, 'alice'
  end

  private

  def initialize_test
    @about = posts(:about)
    @comment = comments(:one)
    @locales = I18n.available_locales
  end
end
