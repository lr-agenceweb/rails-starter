# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == PostCommentsController test
  #
  class PostCommentsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get index page with signalled option disabled' do
      @comment_setting.update_attribute(:should_signal, false)
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @comment
      assert_response :success
    end

    test 'should not be able to show comments for other users' do
      sign_in @subscriber
      get :show, id: @comment
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit a comment' do
      get :edit, id: @comment_administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should render 404 if access new page' do
      assert_raises(ActionController::UrlGenerationError) do
        get :new
      end
    end

    #
    # == Destroy
    #
    # Super Administrator
    test 'should destroy own comment if super_administrator' do
      sign_in @super_administrator
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment
      end
      assert_redirected_to admin_post_comments_path
    end

    test 'should destroy administrator comment if super_administrator' do
      sign_in @super_administrator
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_administrator
      end
      assert_redirected_to admin_post_comments_path
    end

    test 'should destroy subscriber comment if super_administrator' do
      sign_in @super_administrator
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_subscriber
      end
      assert_redirected_to admin_post_comments_path
    end

    # Administrator
    test 'should not be able to destroy SA comment if administrator' do
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should be able to destroy own comment if administrator' do
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_administrator
      end
      assert_redirected_to admin_post_comments_path
    end

    test 'should be able to destroy subscriber comment if administrator' do
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_subscriber
      end
      assert_redirected_to admin_post_comments_path
    end

    # Subscriber
    test 'should not be able to destroy super_administrator comment if subscriber' do
      sign_in @subscriber
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy admin comment if subscriber' do
      sign_in @subscriber
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment_administrator
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should destroy own comment if subscriber' do
      sign_in @subscriber
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_subscriber
      end
      assert_redirected_to admin_post_comments_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_validated batch action' do
      post :batch_action, batch_action: 'toggle_validated', collection_selection: [@comment.id]
      [@comment].each(&:reload)
      assert_not @comment.validated?
    end

    test 'should redirect to back and have correct flash notice for toggle_validated batch action' do
      post :batch_action, batch_action: 'toggle_validated', collection_selection: [@comment.id]
      assert_redirected_to admin_comments_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should return correct value for toggle_signalled batch action' do
      post :batch_action, batch_action: 'toggle_signalled', collection_selection: [@comment.id]
      [@comment].each(&:reload)
      assert @comment.signalled?
    end

    test 'should redirect to back and have correct flash notice for toggle_signalled batch action' do
      post :batch_action, batch_action: 'toggle_signalled', collection_selection: [@comment.id]
      assert_redirected_to admin_comments_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
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
      assert_response :success
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
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.cannot?(:read, @comment), 'should not be able to read'
      assert ability.cannot?(:update, @comment), 'should not be able to update'
      assert ability.cannot?(:destroy, @comment), 'should not be able to destroy'

      assert ability.cannot?(:toggle_validated, @comment), 'should not be able to toggle_validated'
      assert ability.cannot?(:toggle_signalled, @comment), 'should not be able to toggle_signalled'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.can?(:read, @comment), 'should be able to read'
      assert ability.cannot?(:update, @comment), 'should not be able to update'
      assert ability.cannot?(:destroy, @comment), 'should not be able to destroy'

      assert ability.can?(:read, @comment_administrator), 'should be able to read'
      assert ability.cannot?(:update, @comment_administrator), 'should not be able to update'
      assert ability.can?(:destroy, @comment_administrator), 'should be able to destroy'

      assert ability.can?(:toggle_validated, @comment), 'should be able to toggle_validated'
      assert ability.can?(:toggle_signalled, @comment), 'should be able to toggle_signalled'
      assert ability.can?(:toggle_validated, @comment_administrator), 'should be able to toggle_validated'
      assert ability.can?(:toggle_signalled, @comment_administrator), 'should be able to toggle_signalled'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.can?(:read, @comment), 'should be able to read'
      assert ability.cannot?(:update, @comment), 'should not be able to update'
      assert ability.can?(:destroy, @comment), 'should be able to destroy'

      assert ability.can?(:destroy, @comment_subscriber), 'should be able to destroy'
      assert ability.can?(:destroy, @comment_administrator), 'should be able to destroy'

      assert ability.can?(:toggle_validated, @comment), 'should be able to toggle_validated'
      assert ability.can?(:toggle_signalled, @comment), 'should be able to toggle_signalled'
      assert ability.can?(:toggle_validated, @comment_administrator), 'should be able to toggle_validated'
      assert ability.can?(:toggle_signalled, @comment_administrator), 'should be able to toggle_signalled'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@comment, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      get :index
      assert_response :success
      assert_crud_actions(@comment, admin_dashboard_path, model_name, no_index: true)
    end

    #
    # == Module disabled
    #
    test 'should not access page if blog module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_comments_path

      @comment = comments(:one) # comment super_administrator
      @comment_administrator = comments(:two)
      @comment_subscriber = comments(:three)
      @comment_module = optional_modules(:comment)
      @comment_setting = comment_settings(:one)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
