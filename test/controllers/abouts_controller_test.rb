require 'test_helper'

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
    assert_routing '/a-propos', controller: 'abouts', action: 'index', locale: 'fr'
    assert_routing '/en/about', controller: 'abouts', action: 'index', locale: 'en'
  end

  private

  def initialize_test
    @about = posts(:about)
  end
end
