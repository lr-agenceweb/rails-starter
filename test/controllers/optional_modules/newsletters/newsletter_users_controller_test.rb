# frozen_string_literal: true
require 'test_helper'

#
# == NewsletterUsersController Test
#
class NewsletterUsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Subscribing
  #
  test 'should not create if email not properly formatted' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: 'aaabbb.cc', lang: 'fr' }
      assert_not assigns(:newsletter_user).valid?
    end
  end

  test 'should not create if lang is empty' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: '' }
      assert_not assigns(:newsletter_user).valid?
    end
  end

  test 'should not create if lang is not allowed' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: 'de' }
      assert_not assigns(:newsletter_user).valid?
    end
  end

  test 'should not create if captcha is filled' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: @lang, nickname: 'robot' }
      assert_not assigns(:newsletter_user).valid?
    end
  end

  test 'should create if captcha is blank' do
    assert_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: @lang, nickname: '' }
      assert assigns(:newsletter_user).valid?
    end
  end

  test 'should not render template if captcha is filled' do
    post :create, newsletter_user: { email: @email, lang: @lang, nickname: 'robot' }
    assert_response 302
    assert_redirected_to :back
  end

  test 'should create' do
    assert_difference ['NewsletterUser.count'], 1 do
      post :create, newsletter_user: { email: @email, lang: @lang }
    end
  end

  test 'should get correct information after success save' do
    post :create, newsletter_user: { email: @email, lang: @lang }
    newsletter_user = assigns(:newsletter_user)

    assert_equal newsletter_user.email, @email
    assert_equal newsletter_user.lang, @lang
    assert_equal newsletter_user.newsletter_user_role_id, @newsletter_user_role_subscriber.id
    assert_equal newsletter_user.newsletter_user_role_title, 'abonné'
  end

  #
  # == Flash
  #
  # Create
  test 'should have correct flash if create' do
    post :create, newsletter_user: { email: @email, lang: @lang }
    assert_equal I18n.t('newsletter.subscribe_success'), flash[:success]
  end

  test 'should have correct flash if error' do
    post :create, newsletter_user: { email: 'newsletteruser@test.fr', lang: @lang }
    assert_equal I18n.t('newsletter.subscribe_error'), flash[:error]
  end

  test 'AJAX :: should have correct flash if create' do
    xhr :post, :create, newsletter_user: { email: @email, lang: @lang }
    assert_equal I18n.t('newsletter.subscribe_success'), flash[:success]
  end

  test 'AJAX :: should have correct flash if error' do
    xhr :post, :create, newsletter_user: { email: 'newsletteruser@test.fr', lang: @lang }
    assert_equal I18n.t('newsletter.subscribe_error'), flash[:error]
  end

  # Delete
  test 'should have correct flash if unsubscribe' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    assert_equal I18n.t('newsletter.unsubscribe.success'), flash[:success]
  end

  test 'should have correct flash if unsubscribe fails' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: "#{@newsletter_user.token}-abc"
    assert_equal I18n.t('newsletter.unsubscribe.fail'), flash[:error]
  end

  test 'should return correct flash if not found' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: -9, token: @newsletter_user.token
    assert_equal I18n.t('newsletter.unsubscribe.invalid'), flash[:error]
    assert_redirected_to root_url
  end

  test 'AJAX :: should have correct flash if unsubscribe' do
    xhr :delete, :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    assert_equal I18n.t('newsletter.unsubscribe.success'), flash[:success]
  end

  test 'AJAX :: should have correct flash if can\'t unsubscribe' do
    xhr :delete, :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: "#{@newsletter_user.token}-abc"
    assert_equal I18n.t('newsletter.unsubscribe.fail'), flash[:error]
  end

  test 'AJAX :: should return correct flash if not found' do
    xhr :delete, :unsubscribe, locale: 'fr', newsletter_user_id: -9, token: @newsletter_user.token
    assert_equal I18n.t('newsletter.unsubscribe.invalid'), flash[:error]
  end

  #
  # == Ajax
  #
  test 'AJAX :: should create' do
    xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang }
    assert_response :success
  end

  test 'AJAX :: should render show template if created' do
    xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang }
    assert_template :create
  end

  test 'AJAX :: should not create if email is wrong' do
    xhr :post, :create, format: :js, newsletter_user: { email: 'aaabbb.cc', lang: @lang }
    assert_response :unprocessable_entity
    assert_not assigns(:newsletter_user).valid?
  end

  test 'AJAX :: should not create if captcha is filled' do
    assert_no_difference ['NewsletterUser.count'] do
      xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang, nickname: 'robot' }
      assert_not assigns(:newsletter_user).valid?
    end
  end

  test 'AJAX :: should create if captcha is blank' do
    assert_difference ['NewsletterUser.count'] do
      xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang, nickname: '' }
      assert assigns(:newsletter_user).valid?
    end
  end

  test 'AJAX :: should render error template if not being created' do
    xhr :post, :create, format: :js, newsletter_user: { email: 'aaabbb.cc', lang: @lang }
    assert_template :errors
  end

  #
  # == Unsubscribing
  #
  test 'should get redirected to french home after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    assert_redirected_to root_path(locale: 'fr')
  end

  test 'should get redirected to english home after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user_en.id, token: @newsletter_user_en.token
    assert_redirected_to root_path(locale: 'en')
  end

  test 'should unsubscribe if token is correct' do
    assert_difference ['NewsletterUser.count'], -1 do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    end
  end

  test 'should not unsubscribe if token is wrong' do
    assert_no_difference ['NewsletterUser.count'] do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: "#{@newsletter_user.token}-abc"
    end
  end

  #
  # == Mailer
  #
  test 'should send an email when a subscribed' do
    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    assert_enqueued_jobs 1 do
      post :create, newsletter_user: { email: @email, lang: @lang }
    end
  end

  test 'should not send an email when a subscription fails' do
    clear_deliveries_and_queues
    assert ActionMailer::Base.deliveries.empty?

    assert_no_enqueued_jobs do
      post :create, newsletter_user: { email: @email, lang: 'de' }
    end
  end

  test 'should not send an email if captcha is filled' do
    clear_deliveries_and_queues
    assert ActionMailer::Base.deliveries.empty?

    assert_no_enqueued_jobs do
      post :create, newsletter_user: { email: @email, lang: 'de', captcha: 'robot' }
    end
  end

  test 'should not send an email if setting is disabled' do
    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    @newsletter_setting.update_attributes(send_welcome_email: false)

    assert_no_enqueued_jobs do
      post :create, newsletter_user: { email: @email, lang: @lang }
    end
  end

  test 'should have correct email headers and content' do
    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    perform_enqueued_jobs do
      @locales.each do |locale|
        I18n.with_locale(locale) do
          post :create, newsletter_user: { email: "#{@email}#{locale}", lang: locale }
          user = assigns(:newsletter_user)
          delivered_email = ActionMailer::Base.deliveries.last

          assert_not ActionMailer::Base.deliveries.empty?
          assert_includes delivered_email.to, user.email
          assert_includes delivered_email.from, @setting.email
          assert_includes delivered_email.subject, @newsletter_setting.title_subscriber
        end
      end
    end

    assert_performed_jobs @locales.count
  end

  #
  # == Abilities
  #
  test 'should test abilities for subscriber' do
    sign_in @subscriber
    ability = Ability.new(@subscriber)
    assert ability.can?(:unsubscribe, @newsletter_user), 'should be able to unsubscribe'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@subscriber)
    assert ability.cannot?(:unsubscribe, @newsletter_user), 'should not be able to unsubscribe'
  end

  test 'should test abilities for administrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    assert ability.can?(:unsubscribe, @newsletter_user), 'should be able to unsubscribe'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@administrator)
    assert ability.cannot?(:unsubscribe, @newsletter_user), 'should not be able to unsubscribe'
  end

  test 'should test abilities for super_administrator' do
    sign_in @super_administrator
    ability = Ability.new(@super_administrator)
    assert ability.can?(:unsubscribe, @newsletter_user), 'should be able to unsubscribe'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@super_administrator)
    assert ability.cannot?(:unsubscribe, @newsletter_user), 'should not be able to unsubscribe'
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @request.env['HTTP_REFERER'] = root_url
    @setting = settings(:one)

    @newsletter_module = optional_modules(:newsletter)
    @newsletter_setting = newsletter_settings(:one)

    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_en = newsletter_users(:newsletter_user_en)
    @newsletter_user_role_subscriber = newsletter_user_roles(:subscriber)

    @email = 'aaa@bbb.cc'
    @lang = 'fr'

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end

  def clear_deliveries_and_queues
    clear_enqueued_jobs
    clear_performed_jobs
    ActionMailer::Base.deliveries.clear
  end
end
