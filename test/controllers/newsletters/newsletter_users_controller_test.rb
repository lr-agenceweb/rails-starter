require 'test_helper'

#
# == NewsletterUsersController Test
#
class NewsletterUsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Subscribing
  #
  test 'should not create newsletter user if email not properly formatted' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: 'aaabbb.cc', lang: 'fr' }
    end
  end

  test 'should not create newsletter user if lang is empty' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: '' }
    end
  end

  test 'should not create newsletter user if lang is not allowed' do
    assert_no_difference ['NewsletterUser.count'] do
      post :create, newsletter_user: { email: @email, lang: 'de' }
    end
  end

  test 'should create newsletter user' do
    assert_difference ['NewsletterUser.count'], 1 do
      post :create, newsletter_user: { email: @email, lang: @lang }
    end
  end

  test 'should get correct information after success save' do
    post :create, newsletter_user: { email: @email, lang: @lang }
    newsletter_user = assigns(:newsletter_user)

    assert_equal newsletter_user.email, @email
    assert_equal newsletter_user.lang, @lang
    assert_equal newsletter_user.role, 'subscriber'
  end

  # == Ajax
  test 'should create newsletter user by ajax' do
    xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang }
    assert_response :success
  end

  test 'should render show template if newsletter user created by ajax' do
    xhr :post, :create, format: :js, newsletter_user: { email: @email, lang: @lang }
    assert_template :show
  end

  test 'should not create newsletter user by ajax' do
    xhr :post, :create, format: :js, newsletter_user: { email: 'aaabbb.cc', lang: @lang }
    assert_response :unprocessable_entity
  end

  test 'should render error template if newsletter user not being created (when ajax)' do
    xhr :post, :create, format: :js, newsletter_user: { email: 'aaabbb.cc', lang: @lang }
    assert_template :errors
  end

  #
  # == Unsubscribing
  #
  test 'should get redirected to french homepage after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    assert_redirected_to root_path(locale: 'fr')
  end

  test 'should get redirected to english homepage after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user_en.id, token: @newsletter_user_en.token
    assert_redirected_to root_path(locale: 'en')
  end

  test 'should unsubscribe newsletter user if token is correct' do
    assert_difference ['NewsletterUser.count'], -1 do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    end
  end

  test 'should not unsubscribe newsletter user if token is wrong' do
    assert_no_difference ['NewsletterUser.count'] do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: "#{@newsletter_user.token}-abc"
    end
  end

  #
  # == Mailer
  #
  test 'should not send a welcome_user email when a newsletter user subscription fails' do
    clear_deliveries_and_queues
    assert ActionMailer::Base.deliveries.empty?

    assert_no_enqueued_jobs do
      post :create, newsletter_user: { email: @email, lang: 'de' }
    end
  end

  test 'should send a welcome_user email when a newsletter user subscribed' do
    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    assert_enqueued_jobs 1 do
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
          assert_includes delivered_email.from, @settings.email
          assert_includes delivered_email.subject, I18n.t('newsletter.welcome')
        end
      end
    end

    assert_performed_jobs 2
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @request.env['HTTP_REFERER'] = root_url
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_en = newsletter_users(:newsletter_user_en)
    @settings = settings(:one)

    @email = 'aaa@bbb.cc'
    @lang = 'fr'
  end

  def clear_deliveries_and_queues
    clear_enqueued_jobs
    clear_performed_jobs
    ActionMailer::Base.deliveries.clear
  end
end
