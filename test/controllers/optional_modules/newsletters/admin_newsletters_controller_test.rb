# frozen_string_literal: true
require 'test_helper'

#
# Admin namespace
# =================
module Admin
  #
  # NewslettersController test
  # ============================
  class NewslettersControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # Routes / Templates / Responses
    # ================================
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get new page if logged in' do
      get :new
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @newsletter }
      assert_response :success
    end

    #
    # Destroy
    # =========
    test 'should not destroy newsletter if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'Newsletter.count' do
        delete :destroy, params: { id: @newsletter }
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should destroy newsletter if logged in as administrator' do
      assert_difference 'Newsletter.count', -1 do
        delete :destroy, params: { id: @newsletter }
      end
    end

    test 'should redirect to newsletter path after destroy' do
      delete :destroy, params: { id: @newsletter }
      assert_redirected_to admin_newsletters_path
    end

    #
    # Preview
    # =========
    test 'should render preview template and newsletter layout' do
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          get :preview, params: { locale: locale.to_s, id: @newsletter }
          assert_response :success
          assert_template 'newsletter_mailer/send_newsletter', layout: 'newsletter'
        end
      end
    end

    #
    # Mailer
    # ========
    test 'should send email to subscribers' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      assert_enqueued_jobs 2 do
        get :send_newsletter, params: { id: @newsletter_not_sent.id, option: 'subscribers' }
        assert_not assigns(:newsletter).sent_at.nil?
        assert_equal 'La newsletter est en train d\'être envoyée à 2 personnes', flash[:notice]
        assert_redirected_to admin_newsletters_path
      end
    end

    test 'should send email to testers only' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      assert_enqueued_jobs 1 do
        get :send_newsletter, params: { id: @newsletter_not_sent.id, option: 'testers' }
        assert assigns(:newsletter).sent_at.nil?
        assert_equal 'La newsletter est en train d\'être envoyée à 1 personne', flash[:notice]
        assert_redirected_to admin_newsletters_path
      end
    end

    #
    # Maintenance
    # =============
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
    # Abilities
    # ===========
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Newsletter.new), 'should not be able to create'
      assert ability.cannot?(:read, @newsletter), 'should not be able to read'
      assert ability.cannot?(:update, @newsletter), 'should not be able to update'
      assert ability.cannot?(:destroy, @newsletter), 'should not be able to destroy'
      assert ability.cannot?(:preview, @newsletter), 'should not be able to preview'
      assert ability.cannot?(:send, @newsletter), 'should not be able to send'

      @newsletter_module.update_attribute(:enabled, false)
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Newsletter.new), 'should not be able to create'
      assert ability.cannot?(:read, @newsletter), 'should not be able to read'
      assert ability.cannot?(:update, @newsletter), 'should not be able to update'
      assert ability.cannot?(:destroy, @newsletter), 'should not be able to destroy'
      assert ability.cannot?(:preview, @newsletter), 'should not be able to preview'
      assert ability.cannot?(:send, @newsletter), 'should not be able to send'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Newsletter.new), 'should be able to create'
      assert ability.can?(:read, @newsletter), 'should be able to read'
      assert ability.can?(:update, @newsletter), 'should be able to update'
      assert ability.can?(:destroy, @newsletter), 'should be able to destroy'
      assert ability.can?(:preview, @newsletter), 'should be able to preview'
      assert ability.can?(:send, @newsletter), 'should be able to send'

      @newsletter_module.update_attribute(:enabled, false)
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Newsletter.new), 'should not be able to create'
      assert ability.cannot?(:read, @newsletter), 'should not be able to read'
      assert ability.cannot?(:update, @newsletter), 'should not be able to update'
      assert ability.cannot?(:destroy, @newsletter), 'should not be able to destroy'
      assert ability.cannot?(:preview, @newsletter), 'should not be able to preview'
      assert ability.cannot?(:send, @newsletter), 'should not be able to send'
      assert ability.cannot?(:send, @newsletter), 'should not be able to send'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Newsletter.new), 'should be able to create'
      assert ability.can?(:read, @newsletter), 'should be able to read'
      assert ability.can?(:update, @newsletter), 'should be able to update'
      assert ability.can?(:destroy, @newsletter), 'should be able to destroy'
      assert ability.can?(:preview, @newsletter), 'should be able to preview'
      assert ability.can?(:send, @newsletter), 'should be able to send'

      @newsletter_module.update_attribute(:enabled, false)
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Newsletter.new), 'should not be able to create'
      assert ability.cannot?(:read, @newsletter), 'should not be able to read'
      assert ability.cannot?(:update, @newsletter), 'should not be able to update'
      assert ability.cannot?(:destroy, @newsletter), 'should not be able to destroy'
      assert ability.cannot?(:preview, @newsletter), 'should not be able to preview'
      assert ability.cannot?(:send, @newsletter), 'should not be able to send'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@newsletter, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@newsletter, admin_dashboard_path, model_name)
    end

    #
    # Module disabled
    # =================
    test 'should not access page if newsletter module is disabled' do
      disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@newsletter, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@newsletter, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@newsletter, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @newsletter = newsletters(:one)
      @newsletter_not_sent = newsletters(:not_sent)
      @newsletter_user = newsletter_users(:newsletter_user_fr)
      @newsletter_module = optional_modules(:newsletter)
      @request.env['HTTP_REFERER'] = admin_newsletters_path

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
