# frozen_string_literal: true
require 'test_helper'

#
# Admin namespace
# =================
module Admin
  #
  # MailingMessagesController test
  # ================================
  class MailingMessagesControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # Routes / Templates / Responses
    # ================================
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should create mailing_message' do
      post :create, params: { mailing_message: {} }
      assert_redirected_to admin_mailing_message_path(assigns(:mailing_message))
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @mailing_message }
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, params: { id: @mailing_message }
      assert_response :success
    end

    # Valid params
    test 'should update mailing_message if logged in' do
      patch :update, params: { id: @mailing_message, mailing_message: {} }
      assert_redirected_to admin_mailing_message_path(@mailing_message)
    end

    #
    # Redirection after create or update
    # ====================================
    test 'should redirect to edit form after create with picture' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      post :create, params: { mailing_message: { picture_attributes: { image: attachment } } }
      assert_redirected_to edit_admin_mailing_message_path(assigns(:mailing_message))
    end

    test 'should redirect to edit form after update existing picture' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, params: { id: @mailing_message, mailing_message: { picture_attributes: { image: attachment } } }
      assert_redirected_to edit_admin_mailing_message_path(assigns(:mailing_message))
    end

    test 'should redirect to edit form after update with picture' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, params: { id: @mailing_message_without_picture, mailing_message: { picture_attributes: { image: attachment } } }
      assert_redirected_to edit_admin_mailing_message_path(assigns(:mailing_message))
    end

    #
    # Destroy
    # =========
    test 'should not destroy message if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'MailingMessage.count' do
        delete :destroy, params: { id: @mailing_message }
      end
    end

    test 'should destroy mailing message if logged in as admin' do
      assert_difference ['MailingMessage.count', 'Picture.count'], -1 do
        delete :destroy, params: { id: @mailing_message }
      end
    end

    test 'should redirect to mailing users path after destroy' do
      delete :destroy, params: { id: @mailing_message }
      assert_redirected_to admin_mailing_messages_path
    end

    test 'should destroy nested picture if destroy is check' do
      picture_attrs = {
        id: @mailing_message.picture.id,
        _destroy: 'true'
      }
      assert @mailing_message.picture.present?
      assert_difference ['Picture.count'], -1 do
        patch :update, params: { id: @mailing_message, mailing_message: { picture_attributes: picture_attrs } }
        assert assigns(:mailing_message).valid?
        @mailing_message.reload
        assigns(:mailing_message).reload

        assert assigns(:mailing_message).picture.blank?
        assert @mailing_message.picture.blank?
      end
    end

    #
    # Subscriber
    # ============
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@mailing_message, new_user_session_path, model_name, no_show: true)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@mailing_message, admin_dashboard_path, model_name, no_show: true)
    end

    #
    # Preview
    # =========
    test 'should render mailing message preview' do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview, params: { locale: locale.to_s, id: @mailing_message }
          assert_response :success
        end
      end
    end

    #
    # Mailer
    # ========
    test 'should send email for checked users in MailingMessage' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      assert_enqueued_jobs 3 do
        get :send_mailing_message, params: { id: @mailing_message.id, token: @mailing_message.token, option: 'checked' }
        assert_redirected_to root_url
      end
    end

    test 'should send email to all users' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      assert_enqueued_jobs 4 do
        get :send_mailing_message, params: { id: @mailing_message.id, token: @mailing_message.token, option: 'all' }
        assert_redirected_to root_url
      end
    end

    test 'should not send any email if get parameter is empty' do
      clear_deliveries_and_queues

      assert_enqueued_jobs 0 do
        get :send_mailing_message, params: { id: @mailing_message.id, token: @mailing_message.token, option: '' }
        assert_redirected_to admin_dashboard_path
      end
    end

    test 'should not send any email if get parameter is not set' do
      clear_deliveries_and_queues

      assert_enqueued_jobs 0 do
        get :send_mailing_message, params: { id: @mailing_message.id, token: @mailing_message.token }
        assert_redirected_to admin_dashboard_path
      end
    end

    test 'should not send any email if token parameter is empty' do
      clear_deliveries_and_queues

      assert_enqueued_jobs 0 do
        get :send_mailing_message, params: { id: @mailing_message.id, token: '', option: 'all' }
        assert_redirected_to admin_dashboard_path
      end
    end

    test 'should not send any email if token parameter is not set' do
      clear_deliveries_and_queues

      assert_enqueued_jobs 0 do
        assert_raises(ActionController::UrlGenerationError) do
          get :send_mailing_message, params: { id: @mailing_message.id, option: 'all' }
        end
      end
    end

    test 'should have correct flash message while sending email' do
      clear_deliveries_and_queues
      assert_no_enqueued_jobs
      assert ActionMailer::Base.deliveries.empty?

      get :send_mailing_message, params: { id: @mailing_message.id, token: @mailing_message.token, option: 'checked' }
      assert_equal "Le mail est en train d'être envoyé à 3 personne(s)", flash[:notice]
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
      assert ability.cannot?(:create, MailingMessage.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_message), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_message), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_message), 'should not be able to destroy'
      assert ability.cannot?(:send_mailing_message, @mailing_message), 'should not be able to send_mailing_message'
      assert ability.cannot?(:preview, @mailing_message), 'should not be able to preview'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, MailingMessage.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_message), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_message), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_message), 'should not be able to destroy'
      assert ability.cannot?(:preview, @mailing_message), 'should not be able to preview'
      assert ability.cannot?(:send_mailing_message, @mailing_message), 'should not be able to send'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, MailingMessage.new), 'should be able to create'
      assert ability.can?(:read, @mailing_message), 'should be able to read'
      assert ability.can?(:update, @mailing_message), 'should be able to update'
      assert ability.can?(:destroy, @mailing_message), 'should be able to destroy'
      assert ability.can?(:send_mailing_message, @mailing_message), 'should be able to send_mailing_message'
      assert ability.can?(:preview, @mailing_message), 'should be able to preview'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, MailingMessage.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_message), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_message), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_message), 'should not be able to destroy'
      assert ability.cannot?(:preview, @mailing_message), 'should not be able to preview'
      assert ability.cannot?(:send_mailing_message, @mailing_message), 'should not be able to send'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, MailingMessage.new), 'should be able to create'
      assert ability.can?(:read, @mailing_message), 'should be able to read'
      assert ability.can?(:update, @mailing_message), 'should be able to update'
      assert ability.can?(:destroy, @mailing_message), 'should be able to destroy'
      assert ability.can?(:send_mailing_message, @mailing_message), 'should be able to send_mailing_message'
      assert ability.can?(:preview, @mailing_message), 'should be able to preview'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, MailingMessage.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_message), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_message), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_message), 'should not be able to destroy'
      assert ability.cannot?(:preview, @mailing_message), 'should not be able to preview'
      assert ability.cannot?(:send_mailing_message, @mailing_message), 'should not be able to send'
    end

    #
    # Module disabled
    # =================
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
      @mailing_message_without_picture = mailing_messages(:two)
      @mailing_module = optional_modules(:mailing)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
