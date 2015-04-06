require 'test_helper'

# ContactsControllerTest file
class ContactsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'index page should redirect to new page' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_redirected_to(action: :new)
    end
  end

  test 'should get new page' do
    I18n.available_locales.each do |locale|
      get :new, locale: locale.to_s
      assert_response :success
    end
  end

  test 'should use new template' do
    I18n.available_locales.each do |locale|
      get :new, locale: locale.to_s
      assert_template :new
    end
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/contact/formulaire', controller: 'contacts', action: 'new', locale: 'fr'
    assert_routing '/en/contact/form', controller: 'contacts', action: 'new', locale: 'en'
  end
end
