require 'test_helper'

#
# == ApplicationController Test
#
class ApplicationControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should render 404' do
    assert_raises(ActionController::RoutingError) do
      @controller.not_found
    end
  end

  test 'should return correct hostname' do
    make_get_index(assertions) do
      assert_equal 'test.host', assigns(:hostname)
    end
  end

  test 'should return correct language' do
    make_get_index(assertions) do
      assert_equal :fr, assigns(:language)
    end

    make_get_index(assertions, :en) do
      assert_equal :en, assigns(:language)
    end
  end

  test 'should return correct Froala wysiwyg key' do
    assert_equal ({froala_key: Figaro.env.froala_key}), @controller.send(:set_froala_key)
  end

  test 'should not have nil legal_notice content' do
    make_get_index(assertions) do
      assert_not assigns(:legal_notice_category).nil?
      assert_equal 'LegalNotice', assigns(:legal_notice_category).name
    end
  end

  test 'should not have nil module settings content' do
    assert @setting.show_admin_bar?
    make_get_index(assertions) do
      assert_not assigns(:comment_setting_admin_bar).nil?
      assert_not assigns(:guest_book_setting_admin_bar).nil?
    end
  end

  test 'should have nil module settings if admin_bar disabled' do
    @setting.update_attribute(:show_admin_bar, false)
    assert_not @setting.show_admin_bar?
    make_get_index(assertions) do
      assert assigns(:comment_setting_admin_bar).nil?
      assert assigns(:guest_book_setting_admin_bar).nil?
    end
  end

  test 'should not have cookie cnil checked' do
    assert_not @controller.cookie_cnil_check?
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @setting = settings(:one)
  end

  def make_get_index(assertions, loc = I18n.default_locale)
    old_controller = @controller
    @controller = HomesController.new
    get :index, locale: loc
    yield(assertions)
  ensure
    @controller = old_controller
  end
end
