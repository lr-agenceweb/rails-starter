require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should get index' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_response :success
      assert_not_nil @home
    end
  end

  test 'should use index template' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_template :index
    end
  end

  test 'should fetch only online posts' do
    @homes = Home.online
    assert_equal @homes.length, 1
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/', controller: 'homes', action: 'index', locale: 'fr'
    assert_routing '/en', controller: 'homes', action: 'index', locale: 'en'
  end

  private

  def initialize_test
    @home = posts(:home)
  end
end
