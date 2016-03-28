# frozen_string_literal: true
require 'test_helper'

#
# == ContactsController Test
#
class ContactsControllerTest < ActionController::TestCase
  include UserHelper
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Routes / Templates / Responses
  #
  test 'index page should redirect to new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_redirected_to(action: :new)
      end
    end
  end

  test 'should get new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'should use new template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :new, locale: locale.to_s
        assert_template :new
      end
    end
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/contact/formulaire', controller: 'contacts', action: 'new', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/contact/form', controller: 'contacts', action: 'new', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Form
  #
  test 'should send a contact message if all fields are valid' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: { email: 'john@test.com', name: 'john', message: 'Thanks for this site', nickname: '' }
        assert assigns(:contact_form).valid?
        assert_redirected_to new_contact_path
      end
    end
  end

  test 'should deliver successfully a message' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference 'ActionMailer::Base.deliveries.size', 1 do
          post :create, locale: locale.to_s, contact_form: {
            name: 'cristiano',
            email: 'cristiano@ronaldo.pt',
            message: 'Hi',
            send_copy: '0'
          }
        end

        assert_redirected_to new_contact_path
        last_email = ActionMailer::Base.deliveries.last

        assert_equal 'Message envoyé par le site Rails Starter', I18n.t('contact.email.subject', site: @setting.title, locale: I18n.default_locale)
        assert_equal 'demo@rails-starter.com', last_email.to[0]
        assert_equal 'cristiano@ronaldo.pt', last_email.from[0]
        assert_match(/Hi/, last_email.text_part.body.to_s)
        assert_match(/Hi/, last_email.html_part.body.to_s)

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should deliver successfully a message and copy to sender' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        ActionMailer::Base.deliveries.clear
        assert_difference 'ActionMailer::Base.deliveries.size', 2 do
          post :create, locale: locale.to_s, contact_form: {
            name: 'cristiano',
            email: 'cristiano@ronaldo.pt',
            message: 'Hi',
            send_copy: '1'
          }
        end

        assert_redirected_to new_contact_path
        contact_email = ActionMailer::Base.deliveries.first
        cc_email = ActionMailer::Base.deliveries.last

        # Contact to admin
        assert_equal 'Message envoyé par le site Rails Starter', I18n.t('contact.email.subject', site: @setting.title, locale: I18n.default_locale)
        assert_equal 'demo@rails-starter.com', contact_email.to[0]
        assert_equal 'cristiano@ronaldo.pt', contact_email.from[0]
        assert_match(/Hi/, contact_email.text_part.body.to_s)
        assert_match(/Hi/, contact_email.html_part.body.to_s)

        # Carbon Copy
        subject_cc = 'Copie de votre message de contact envoyé à Rails Starter' if locale.to_s == 'fr'
        subject_cc = 'Copy of your contact message sent to Rails Starter website' if locale.to_s == 'en'
        assert_equal subject_cc, I18n.t('contact.email.subject_cc', site: @setting.title)
        assert_equal 'demo@rails-starter.com', cc_email.from[0]
        assert_equal 'cristiano@ronaldo.pt', cc_email.to[0]
        assert_match(/Hi/, cc_email.text_part.body.to_s)
        assert_match(/Hi/, cc_email.html_part.body.to_s)

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should not send a contact message if fields are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: { name: '', email: '', message: '', send_copy: '' }
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'should not send a contact message if email is not correct' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: { email: 'johnletesteur.com' }
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'should not send a contact message if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: { email: 'john@test.fr', name: 'john', message: 'Thanks for this site', nickname: 'I am a robot' }
        assert_template :new
      end
    end
  end

  test 'should redirect to index if try to access map popup' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :mapbox_popup, locale: locale.to_s
        assert_redirected_to contacts_path
      end
    end
  end

  test 'should have correct flash content after sending' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: { email: 'john@test.com', name: 'john', message: 'Thanks for this site', nickname: '' }
        assert_equal @string_box_success.content, flash[:success]
      end
    end
  end

  #
  # == Ajax
  #
  test 'AJAX :: should redirect to new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :index, format: :js, locale: locale.to_s
        assert_redirected_to(action: :new)
      end
    end
  end

  test 'AJAX :: should get new page' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :new, format: :js, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'AJAX :: should use new template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :new, format: :js, locale: locale.to_s
        assert_template :new
      end
    end
  end

  test 'AJAX :: should send a message if all fields are valid' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, contact_form: { email: 'john@test.fr', name: 'john', message: 'Thanks for this site', nickname: '' }
        assert assigns(:contact_form).valid?
        assert_template :create
      end
    end
  end

  test 'AJAX :: should not send a message if fields are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, contact_form: { name: '', email: '', message: '', send_copy: '' }
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'AJAX :: should not send a message if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, contact_form: { email: 'john@test.fr', name: 'john', message: 'Thanks for this site', nickname: 'I am a robot' }
        assert_template :new
      end
    end
  end

  test 'AJAX :: should use correct action and no layout for popup' do
    @setting.update_attribute(:show_map, true)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :mapbox_popup, locale: locale.to_s
        assert_template :mapbox_popup
        assert_template layout: false
      end
    end
  end

  test 'AJAX :: should not render popup if location not set' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :mapbox_popup, locale: locale.to_s
        assert_template nil
        assert_template layout: false
      end
    end
  end

  test 'AJAX :: should have correct flash content after sending' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, locale: locale.to_s, contact_form: { email: 'john@test.com', name: 'john', message: 'Thanks for this site', nickname: '' }
        assert_equal @string_box_success.content, flash[:success]
      end
    end
  end

  #
  # == Menu offline
  #
  test 'should render 404 if menu item is offline' do
    @menu.update_attribute(:online, false)
    assert_not @menu.online, 'menu item should be offline'

    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :new, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Abilities
  #
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
  # == Maintenance
  #
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

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
