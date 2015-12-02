require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == AboutsController test
  #
  class AboutsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @about
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @about
      assert_response :success
    end

    test 'should update about if logged in' do
      patch :update, id: @about, about: {}
      assert_redirected_to admin_about_path(@about)
    end

    test 'should destroy about' do
      assert_difference ['About.count', 'Referencement.count'], -1 do
        delete :destroy, id: @about
      end
      assert_redirected_to admin_abouts_path
    end

    #
    # == Comments
    #
    test 'should destroy comments with post' do
      assert_equal 5, @about.comments.size
      delete :destroy, id: @about
      assert_equal 0, @about.comments.size
      assert @about.comments.empty?
    end

    #
    # == Validations
    #
    test 'should not save allow_comments params if module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @about, about: { allow_comments: false }
      assert assigns(:about).allow_comments?
    end

    test 'should save allow_comments params if module is enabled' do
      patch :update, id: @about, about: { allow_comments: false }
      assert_not assigns(:about).allow_comments?
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend
    end

    test 'should render maintenance if enabled and subscriber' do
      sign_in @subscriber
      assert_maintenance_backend
      assert_redirected_to admin_dashboard_path
    end

    test 'should redirect to login if maintenance and not connected' do
      sign_out @administrator
      assert_maintenance_backend
      assert_redirected_to new_user_session_path
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, About.new), 'should not be able to create'
      assert ability.cannot?(:read, @about), 'should not be able to read'
      assert ability.cannot?(:update, @about), 'should not be able to update'
      assert ability.cannot?(:destroy, @about), 'should not be able to destroy'

      assert ability.cannot?(:read, @about_super_administrator), 'should not be able to read super_administrator'
      assert ability.cannot?(:update, @about_super_administrator), 'should not be able to update super_administrator'
      assert ability.cannot?(:destroy, @about_super_administrator), 'should not be able to destroy super_administrator'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, About.new), 'should be able to create'
      assert ability.can?(:read, @about), 'should be able to read'
      assert ability.can?(:update, @about), 'should be able to update'
      assert ability.can?(:destroy, @about), 'should be able to destroy'

      assert ability.cannot?(:read, @about_super_administrator), 'should not be able to read super_administrator'
      assert ability.cannot?(:update, @about_super_administrator), 'should not be able to update super_administrator'
      assert ability.cannot?(:destroy, @about_super_administrator), 'should not be able to destroy super_administrator'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, About.new), 'should be able to create'
      assert ability.can?(:read, @about), 'should be able to read'
      assert ability.can?(:update, @about), 'should be able to update'
      assert ability.can?(:destroy, @about), 'should be able to destroy'

      assert ability.can?(:read, @about_super_administrator), 'should be able to read super_administrator'
      assert ability.can?(:update, @about_super_administrator), 'should be able to update super_administrator'
      assert ability.can?(:destroy, @about_super_administrator), 'should be able to destroy super_administrator'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@about, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@about, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @about = posts(:about_2)
      @about_super_administrator = posts(:about)
      @comment_module = optional_modules(:comment)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end

# TODO: Add test for create