require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == NewslettersController test
  #
  class NewslettersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@newsletter, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @newsletter
      assert_response :success
    end

    #
    # == Destroy
    #
    test 'should not destroy newsletter if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'Newsletter.count' do
        delete :destroy, id: @newsletter
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should destroy newsletter if logged in as administrator' do
      assert_difference 'Newsletter.count', -1 do
        delete :destroy, id: @newsletter
      end
    end

    test 'should redirect to newsletter path after destroy' do
      delete :destroy, id: @newsletter
      assert_redirected_to admin_newsletters_path
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Newsletter.new), 'should not be able to create'
      assert ability.cannot?(:read, Newsletter.new), 'should not be able to read'
      assert ability.cannot?(:update, Newsletter.new), 'should not be able to update'
      assert ability.cannot?(:destroy, Newsletter.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Newsletter.new), 'should be able to create'
      assert ability.can?(:read, Newsletter.new), 'should be able to read'
      assert ability.can?(:update, Newsletter.new), 'should be able to update'
      assert ability.can?(:destroy, Newsletter.new), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Newsletter.new), 'should be able to create'
      assert ability.can?(:read, Newsletter.new), 'should be able to read'
      assert ability.can?(:update, Newsletter.new), 'should be able to update'
      assert ability.can?(:destroy, Newsletter.new), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access newsletter as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@newsletter, admin_dashboard_path)
    end

    #
    # == Module disabled
    #
    test 'should not access page if newsletter module is disabled' do
      disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@newsletter, admin_dashboard_path)
      sign_in @administrator
      get :index
      assert_crud_actions(@newsletter, admin_dashboard_path)
      sign_in @subscriber
      get :index
      assert_crud_actions(@newsletter, admin_dashboard_path)
    end

    private

    def initialize_test
      @newsletter = newsletters(:one)
      @newsletter_module = optional_modules(:newsletter)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
