require 'test_helper'

#
# == ContactsController Test
#
class ContactsControllerTest < ActionController::TestCase
  include UserHelper
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

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
  # # TODO: Fix this broken test
  # test 'should send a contact message if all fields are valid' do
  #   @locales.each do |locale|
  #     I18n.with_locale(locale.to_s) do
  #       post :create, locale: locale.to_s, contact_form: { email: 'john@test.com', username: 'john', message: 'Thanks for this site', nickname: '' }
  #       assert assigns(:contact_form).valid?
  #       assert assigns(:contact_form).deliver
  #       assert_redirected_to new_contact_path
  #     end
  #   end
  # end

  test 'should not send a contact message if fields are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, contact_form: {}
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'should not send a contact message if email is not properly formatted' do
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
        post :create, locale: locale.to_s, contact_form: { email: 'john@test.fr', username: 'john', message: 'Thanks for this site', nickname: 'I am a robot' }
        assert_redirected_to new_contact_path
      end
    end
  end

  test 'should redirect to index action if try to access mapbox popup action' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :mapbox_popup, locale: locale.to_s
        assert_redirected_to contacts_path
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

  # # TODO: Fix this broken test
  # test 'AJAX :: should send a contact message if all fields are valid' do
  #   @locales.each do |locale|
  #     I18n.with_locale(locale.to_s) do
  #       xhr :post, :create, format: :js, locale: locale.to_s, contact_form: { email: 'john@test.fr', username: 'john', message: 'Thanks for this site', nickname: '' }
  #       assert assigns(:contact_form).valid?
  #       # assert_template :create
  #     end
  #   end
  # end

  test 'AJAX :: should not send a contact message if fields are not valid' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, contact_form: {}
        assert_not assigns(:contact_form).valid?
        assert_template :new
      end
    end
  end

  test 'AJAX :: should not send a contact message if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, contact_form: { email: 'john@test.fr', username: 'john', message: 'Thanks for this site', nickname: 'I am a robot' }
        assert_template :create
      end
    end
  end

  test 'AJAX :: should use correct action and no layout for mapbox popup action' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :mapbox_popup, locale: locale.to_s
        assert_template :mapbox_popup
        assert_template layout: false
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
  end
end
