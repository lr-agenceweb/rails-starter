# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == AudiosController test
  #
  class AudiosControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, params: { id: @audio }
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @audio }
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, params: { id: @audio, audio: {} }
      assert_redirected_to admin_audio_path(@audio)
    end

    test 'should update audio and enqueued it' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      assert_enqueued_jobs 1 do
        patch :update, params: { id: @audio, audio: { audio: audio } }
      end
    end

    test 'should destroy Audio' do
      assert_difference 'Audio.count', -1 do
        delete :destroy, params: { id: @audio }
      end
      assert_redirected_to admin_audios_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@audio.id] }
      [@audio].each(&:reload)
      assert_not @audio.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@audio.id] }
      assert_redirected_to admin_audios_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    #
    # == Flash content
    #
    test 'should return empty flash notice if no update' do
      patch :update, params: { id: @audio, audio: {} }
      assert flash[:notice].blank?
    end

    test 'should return empty flash notice if destroy' do
      delete :destroy, params: { id: @audio }
      assert flash[:notice].blank?
    end

    test 'should return correct flash content after updating an audio file' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      patch :update, params: { id: @audio, audio: { audio: audio } }
      assert_equal [I18n.t('audio.flash.upload_in_progress')], flash[:notice]
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@audio, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@audio, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if audio module is disabled' do
      disable_optional_module @super_administrator, @audio_module, 'Audio' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@audio, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@audio, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@audio, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, Audio.new), 'should not be able to create'
      assert ability.cannot?(:read, @audio), 'should not be able to read'
      assert ability.cannot?(:update, @audio), 'should not be able to update'
      assert ability.cannot?(:destroy, @audio), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @audio), 'should not be able to toggle_online'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Audio.new), 'should not be able to create'
      assert ability.can?(:read, @audio), 'should be able to read'
      assert ability.can?(:update, @audio), 'should be able to update'
      assert ability.can?(:destroy, @audio), 'should be able to destroy'

      assert ability.can?(:toggle_online, @audio), 'should be able to toggle_online'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Audio.new), 'should not be able to create'
      assert ability.can?(:read, @audio), 'should be able to read'
      assert ability.can?(:update, @audio), 'should be able to update'
      assert ability.can?(:destroy, @audio), 'should be able to destroy'

      assert ability.can?(:toggle_online, @audio), 'should be able to toggle_online'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_audios_path

      @audio = audios(:one)
      @audio_module = optional_modules(:audio)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
