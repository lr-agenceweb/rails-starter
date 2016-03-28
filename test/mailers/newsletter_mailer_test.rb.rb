# frozen_string_literal: true
require 'test_helper'

#
# == Newsletter Mailer test class
#
class NewsletterMailerTest < ActionMailer::TestCase
  include ActionController::TemplateAssertions

  setup :initialize_test

  test 'should use correct template and layout for welcome_user' do
    NewsletterMailer.welcome_user(@newsletter_user).deliver_now
    assert_template :welcome_user
    assert_template layout: 'newsletter'
  end

  test 'should use correct template and layout for send_newsletter' do
    NewsletterMailer.send_newsletter(@newsletter_user, @newsletter).deliver_now
    assert_template :send_newsletter
    assert_template layout: 'newsletter'
  end

  test 'should send welcome newsletter with default headers' do
    clear_deliveries_and_queues

    email = NewsletterMailer.welcome_user(@newsletter_user).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@newsletter_user.email], email.to
    assert_equal [@setting.email], email.from
    assert_equal @newsletter_setting.title_subscriber, email.subject
  end

  test 'should send newsletter with default headers' do
    clear_deliveries_and_queues

    email = NewsletterMailer.send_newsletter(@newsletter_user, @newsletter).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@newsletter_user.email], email.to
    assert_equal [@setting.email], email.from
    assert_equal @newsletter.title, email.subject
  end

  test 'should send newsletter with custom headers' do
    @setting.update_attribute(:email, 'newemail@starter.com')

    email = NewsletterMailer.send_newsletter(@newsletter_user, @newsletter).deliver_now
    assert_equal ['newemail@starter.com'], email.from
  end

  private

  def initialize_test
    @setting = settings(:one)
    @newsletter = newsletters(:one)
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_setting = newsletter_settings(:one)
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
