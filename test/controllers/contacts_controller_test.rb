
# frozen_string_literal: true
require 'test_helper'

#
# ContactsController test
# =========================
class ContactsControllerTest < ActionController::TestCase
  include UserHelper
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # Routes / Templates / Responses
  # ================================
  test 'index page should redirect to new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s }
        assert_redirected_to(action: :new)
      end
    end
  end

  test 'should get new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, params: { locale: locale.to_s }
        assert_response :success
      end
    end
  end

  test 'should use new template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, params: { locale: locale.to_s }
        assert_template :new
      end
    end
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/contact/formulaire', controller: 'contacts', action: 'new', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/contact/form', controller: 'contacts', action: 'new', locale: 'en' if @locales.include?(:en)
  end

  #
  # Form
  # ======
  test 'should send a contact message if all fields are valid' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, params: { locale: locale.to_s, contact_form: { email: 'john@test.com', name: 'john', message: 'Thanks for this site', nickname: '' } }
        assert assigns(:contact_form).valid?
        assert_redirected_to new_contact_path
      end
    end
  end

  test 'should deliver successfully a message' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference 'ActionMailer::Base.deliveries.size', 1 do
          post :create, params: { locale: locale.to_s, contact_form: default_attrs }
        end

        assert_redirected_to new_contact_path
      end
    end
  end

  test 'should deliver successfully a message and copy to sender' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        ActionMailer::Base.deliveries.clear
        assert_difference 'ActionMailer::Base.deliveries.size', 2 do
          post :create, params: { locale: locale.to_s, contact_form: default_attrs('1') }
        end

        assert_redirected_to new_contact_path
      end
    end
  end

  test 'should deliver successfully a message with answering phone' do
    @setting.update_attribute(:answering_machine, true)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference 'ActionMailer::Base.deliveries.size', 2 do
          post :create, params: { locale: locale.to_s, contact_form: default_attrs }
        end

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should not send a contact message if fields are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, params: { locale: locale.to_s, contact_form: default_attrs('', '', '', '') }
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'should not send a contact message if email is not correct' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, params: { locale: locale.to_s, contact_form: default_attrs('0', 'johnletesteur.com') }
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'should not send a contact message if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        attrs = default_attrs
        attrs[:nickname] = 'I am a robot'
        post :create, params: { locale: locale.to_s, contact_form: attrs }
        assert_template :new
      end
    end
  end

  test 'should redirect to index if try to access map popup' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :mapbox_popup, params: { locale: locale.to_s }
        assert_redirected_to contacts_path
      end
    end
  end

  test 'should have correct flash content after sending' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        attrs = default_attrs
        attrs[:nickname] = ''
        post :create, params: { locale: locale.to_s, contact_form: attrs }
        assert_equal @string_box_success.content, flash[:success]
      end
    end
  end

  #
  # Ajax
  # ======
  test 'AJAX :: should redirect to new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { format: :js, locale: locale.to_s }, xhr: true
        assert_redirected_to(action: :new)
      end
    end
  end

  test 'AJAX :: should get new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, params: { format: :js, locale: locale.to_s }, xhr: true
        assert_response :success
      end
    end
  end

  test 'AJAX :: should use new template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, params: { format: :js, locale: locale.to_s }, xhr: true
        assert_template :new
      end
    end
  end

  test 'AJAX :: should send a message if all fields are valid' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        attrs = default_attrs
        attrs[:nickname] = ''
        post :create, params: { format: :js, locale: locale.to_s, contact_form: attrs }, xhr: true
        assert assigns(:contact_form).valid?
        assert_template :create
      end
    end
  end

  test 'AJAX :: should not send a message if fields are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, params: { format: :js, locale: locale.to_s, contact_form: default_attrs('', '', '', '') }, xhr: true
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'AJAX :: should not send a message if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        attrs = default_attrs
        attrs[:nickname] = 'I am a robot'
        post :create, params: { format: :js, locale: locale.to_s, contact_form: attrs }, xhr: true
        assert_template :new
      end
    end
  end

  test 'AJAX :: should use correct action and no layout for popup' do
    @map_setting.update_attribute(:show_map, true)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :mapbox_popup, params: { locale: locale.to_s }, xhr: true
        assert_template :mapbox_popup
        assert_template layout: false
      end
    end
  end

  test 'AJAX :: should not render popup if location not set' do
    @map_setting.location.destroy
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :mapbox_popup, params: { locale: locale.to_s }, xhr: true
        assert_template nil
        assert_template layout: false
      end
    end
  end

  test 'AJAX :: should have correct flash content after sending' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        attrs = default_attrs
        attrs[:nickname] = ''
        post :create, params: { locale: locale.to_s, contact_form: attrs }, xhr: true
        assert_equal @string_box_success.content, flash[:success]
      end
    end
  end

  #
  # Menu offline
  # ==============
  test 'should render 404 if menu item is offline' do
    @menu.update_attribute(:online, false)
    assert_not @menu.online, 'menu item should be offline'

    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :new, params: { locale: locale.to_s }
        end
      end
    end
  end

  #
  # Abilities
  # ===========
  test 'should test abilities for subscriber' do
    sign_in @subscriber
    ability = Ability.new(@subscriber)
    assert ability.can?(:mapbox_popup, Contact.new), 'should be able to see mapbox_popup'
  end

  test 'should test abilities for administrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    assert ability.can?(:mapbox_popup, Contact.new), 'should be able to see mapbox_popup'
  end

  test 'should test abilities for super_administrator' do
    sign_in @super_administrator
    ability = Ability.new(@super_administrator)
    assert ability.can?(:mapbox_popup, Contact.new), 'should be able to see mapbox_popup'
  end

  #
  # Maintenance
  # =============
  test 'should not render maintenance even if enabled and SA' do
    sign_in @super_administrator
    assert_no_maintenance_frontend(:new)
  end

  test 'should not render maintenance even if enabled and Admin' do
    sign_in @administrator
    assert_no_maintenance_frontend(:new)
  end

  test 'should render maintenance if enabled and subscriber' do
    sign_in @subscriber
    assert_maintenance_frontend(:new)
  end

  test 'should render maintenance if enabled and not connected' do
    assert_maintenance_frontend(:new)
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @setting = settings(:one)

    @menu = menus(:contact)
    @string_box_success = string_boxes(:success_contact_form)
    @map_setting = map_settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end

  def default_attrs(send_copy = '0', email = 'cristiano@ronaldo.pt', name = 'cristiano', message = 'Hi')
    {
      name: name,
      email: email,
      message: message,
      send_copy: send_copy
    }
  end
end
