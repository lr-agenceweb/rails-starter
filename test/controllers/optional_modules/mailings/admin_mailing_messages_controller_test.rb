require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MailingMessagesController test
  #
  class MailingMessagesControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @mailing_message
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @mailing_message
      assert_response :success
    end

    # Valid params
    test 'should update mailing_message if logged in' do
      patch :update, id: @mailing_message, mailing_message: {}
      assert_redirected_to admin_mailing_message_path(@mailing_message)
    end

    #
    # == Destroy
    #
    test 'should not destroy message if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'MailingMessage.count' do
        delete :destroy, id: @mailing_message
      end
    end

    test 'should destroy mailing message if logged in as administrator' do
      assert_difference 'MailingMessage.count', -1 do
        delete :destroy, id: @mailing_message
      end
    end

    test 'should redirect to mailing users path after destroy' do
      delete :destroy, id: @mailing_message
      assert_redirected_to admin_mailing_messages_path
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@mailing_message, new_user_session_path, model_name, no_show: true)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@mailing_message, admin_dashboard_path, model_name, no_show: true)
    end

    #
    # == Preview
    #
    test 'should render mailing message preview' do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview, locale: locale.to_s, id: @mailing_message.id
          assert_response :success
        end
      end
    end

    #
    # == Mailer
    #
    test 'should have correct enqueud mails number' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      assert_enqueued_jobs 3 do
        get :send_mailing_message, id: @mailing_message.id
        assert_redirected_to root_url
      end
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
      assert ability.cannot?(:create, MailingMessage.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_message), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_message), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_message), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, MailingMessage.new), 'should be able to create'
      assert ability.can?(:read, @mailing_message), 'should be able to read'
      assert ability.can?(:update, @mailing_message), 'should be able to update'
      assert ability.can?(:destroy, @mailing_message), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, MailingMessage.new), 'should be able to create'
      assert ability.can?(:read, @mailing_message), 'should be able to read'
      assert ability.can?(:update, @mailing_message), 'should be able to update'
      assert ability.can?(:destroy, @mailing_message), 'should be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if mailing module is disabled' do
      disable_optional_module @super_administrator, @mailing_module, 'Mailing' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@mailing_message, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@mailing_message, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@mailing_message, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @locales = I18n.available_locales
      @request.env['HTTP_REFERER'] = root_url
      @setting = settings(:one)
      @mailing_message = mailing_messages(:one)
      @mailing_module = optional_modules(:mailing)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end

    def clear_deliveries_and_queues
      clear_enqueued_jobs
      clear_performed_jobs
      ActionMailer::Base.deliveries.clear
    end
  end
end
