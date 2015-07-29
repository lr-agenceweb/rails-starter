require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == StringBoxesController test
  #
  class StringBoxesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@string_box, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should visit show page if logged in' do
      get :show, id: @string_box
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @string_box
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @string_box, string_box: {}
      assert_redirected_to admin_string_box_path(@string_box)
    end

    test 'should not destroy string_box' do
      assert_no_difference 'StringBox.count' do
        delete :destroy, id: @string_box
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == User role
    #
    test 'should redirect to dashboard page if trying to access string_box as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@string_box, admin_dashboard_path)
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, StringBox.new), 'should not be able to create'
      assert ability.cannot?(:read, @string_box), 'should not be able to read'
      assert ability.cannot?(:update, @string_box), 'should not be able to update'
      assert ability.cannot?(:destroy, @string_box), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, StringBox.new), 'should not be able to create'
      assert ability.can?(:read, @string_box), 'should be able to read'
      assert ability.can?(:update, @string_box), 'should be able to update'
      assert ability.cannot?(:destroy, @string_box), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, StringBox.new), 'should be able to create'
      assert ability.can?(:read, @string_box), 'should be able to read'
      assert ability.can?(:update, @string_box), 'should be able to update'
      assert ability.can?(:destroy, @string_box), 'should be able to destroy'
    end

    private

    def initialize_test
      @string_box = string_boxes(:error_404)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
