require 'test_helper'

#
# == AboutsController Test
#
class AboutsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

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
    assert_equal @abouts.length, 3
  end

  test 'should get abouts page by url' do
    assert_routing '/a-propos', controller: 'abouts', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/about', controller: 'abouts', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Translations
  #
  test 'should get show page with all locales' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @about
        assert_response :success
        assert_not_nil @about
      end
    end
  end

  test 'assert integrity of request for each locales' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @about
        assert_equal request.path_parameters[:id], @about.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  #
  # == Comments
  #
  test 'should get two comments for about article' do
    assert_equal @about.comments.count, 5
  end

  test 'should get alice as comments author' do
    assert_equal @comment.user_username, 'alice'
  end

  private

  def initialize_test
    @about = posts(:about)
    @comment = comments(:three)
    @locales = I18n.available_locales
  end
end
