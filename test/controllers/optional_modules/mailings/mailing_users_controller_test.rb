# frozen_string_literal: true
require 'test_helper'

#
# == MailingUsersController Test
#
class MailingUsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Unsubscribing
  #
  test 'should render success unsubscribe template' do
    delete :unsubscribe, params: { locale: @mailing_user.lang, id: @mailing_user.id, token: @mailing_user.token }
    assert_template :success_unsubscribe
  end

  test 'should unsubscribe newsletter user if token is correct' do
    assert_difference ['MailingUser.count'], -1 do
      delete :unsubscribe, params: { locale: @mailing_user.lang, id: @mailing_user.id, token: @mailing_user.token }
    end
  end

  test 'should not unsubscribe newsletter user if token is wrong' do
    assert_no_difference ['MailingUser.count'] do
      assert_raises(ActionController::RoutingError) do
        delete :unsubscribe, params: { locale: @mailing_user.lang, id: @mailing_user.id, token: "#{@mailing_user.token}-abc" }
      end
    end
  end

  test 'should not unsubscribe newsletter user N°2 by N°1' do
    assert_no_difference ['MailingUser.count'] do
      assert_raises(ActionController::RoutingError) do
        delete :unsubscribe, params: { locale: @mailing_user.lang, id: @mailing_user_two.id, token: @mailing_user.token }
      end
    end
  end

  #
  # == Abilities
  #
  test 'should test abilities for subscriber' do
    sign_in @subscriber
    ability = Ability.new(@subscriber)
    assert ability.can?(:unsubscribe, @mailing_user), 'should be able to unsubscribe'

    @mailing_module.update_attribute(:enabled, false)
    ability = Ability.new(@subscriber)
    assert ability.cannot?(:unsubscribe, @mailing_user), 'should not be able to unsubscribe'
  end

  test 'should test abilities for administrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    assert ability.can?(:unsubscribe, @mailing_user), 'should be able to unsubscribe'

    @mailing_module.update_attribute(:enabled, false)
    ability = Ability.new(@administrator)
    assert ability.cannot?(:unsubscribe, @mailing_user), 'should not be able to unsubscribe'
  end

  test 'should test abilities for super_administrator' do
    sign_in @super_administrator
    ability = Ability.new(@super_administrator)
    assert ability.can?(:unsubscribe, @mailing_user), 'should be able to unsubscribe'

    @mailing_module.update_attribute(:enabled, false)
    ability = Ability.new(@super_administrator)
    assert ability.cannot?(:unsubscribe, @mailing_user), 'should not be able to unsubscribe'
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @mailing_module, 'Mailing' # in test_helper.rb
    assert_raises(ActionController::RoutingError) do
      delete :unsubscribe, params: { locale: @mailing_user.lang, id: @mailing_user.id, token: @mailing_user.token }
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @mailing_user = mailing_users(:one)
    @mailing_user_two = mailing_users(:two)
    @setting = settings(:one)
    @mailing_module = optional_modules(:mailing)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
