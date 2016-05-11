# frozen_string_literal: true
require 'test_helper'

#
# == ActiveUser Mailer test class
#
class ActiveUserMailerTest < ActionMailer::TestCase
  include ActionController::TemplateAssertions

  setup :initialize_test

  test 'should use correct template and layout' do
    ActiveUserMailer.send_email(@user).deliver_now
    assert_template :send_email
    assert_template layout: []
  end

  test 'should send email' do
    email = ActiveUserMailer.send_email(@user).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@setting.email], email.from
    assert_equal [@user.email], email.to
    assert_equal I18n.t('user.email.account_validated.subject', site: @setting.title, locale: I18n.default_locale), email.subject
  end

  private

  def initialize_test
    @setting = settings(:one)
    @user = users(:bart)
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
