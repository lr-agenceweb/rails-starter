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
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@about, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @about
      assert_response :success
    end

    test 'should show edit page if logged in' do
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
      delete :destroy, id: @about
      assert_equal 0, @about.comments.size
      assert @about.comments.empty?
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
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access blog as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@about, admin_dashboard_path)
    end

    private

    def initialize_test
      @about = posts(:about_2)
      @about_super_administrator = posts(:about)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end

# TODO: Add test for create
