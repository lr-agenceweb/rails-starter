require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == BlogsController test
  #
  class BlogsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@blog, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access new page if logged in' do
      get :new
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @blog
      assert_response :success
    end

    test 'should destroy blog' do
      assert_difference ['Blog.count'], -1 do
        delete :destroy, id: @blog
      end
      assert_redirected_to admin_blogs_path
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Blog.new), 'should not be able to create'
      assert ability.cannot?(:read, @blog), 'should not be able to read'
      assert ability.cannot?(:update, @blog), 'should not be able to update'
      assert ability.cannot?(:destroy, @blog), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @blog), 'should be able to read'
      assert ability.can?(:update, @blog), 'should be able to update'
      assert ability.can?(:destroy, @blog), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @blog), 'should be able to read'
      assert ability.can?(:update, @blog), 'should be able to update'
      assert ability.can?(:destroy, @blog), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access blog as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@blog, admin_dashboard_path)
    end

    #
    # == Module disabled
    #
    test 'should not access page if blog module is disabled' do
      disable_optional_module @super_administrator, @blog_module, 'Blog' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@blog, admin_dashboard_path)
      sign_in @administrator
      assert_crud_actions(@blog, admin_dashboard_path)
      sign_in @subscriber
      assert_crud_actions(@blog, admin_dashboard_path)
    end

    private

    def initialize_test
      @request.env['HTTP_REFERER'] = admin_blogs_path
      @blog = blogs(:blog_online)
      @blog_not_validate = blogs(:blog_offline)
      @blog_module = optional_modules(:blog)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
