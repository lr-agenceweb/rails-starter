# frozen_string_literal: true
require 'test_helper'

#
# MailingMessageMailer test
# ===========================
class MailingMessageMailerTest < ActionMailer::TestCase
  include Rails::Controller::Testing::TemplateAssertions

  setup :initialize_test

  test 'should use correct template and layout' do
    opts = set_opts
    MailingMessageMailer.send_email(opts).deliver_now
    assert_template :send_email
    assert_template layout: 'mailers/mailing'
  end

  test 'should send email with default headers' do
    clear_deliveries_and_queues

    opts = set_opts
    email = MailingMessageMailer.send_email(opts).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@mailing_user.email], email.to
    assert_equal [@setting.email], email.from
    assert_equal "[#{@setting.title}] #{@mailing_message.title}", email.subject
  end

  test 'should send email with custom headers' do
    @mailing_setting.update_attribute(:email, 'customemail@host.com')
    assert_equal 'customemail@host.com', @mailing_setting.email

    clear_deliveries_and_queues

    opts = set_opts
    email = MailingMessageMailer.send_email(opts).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@mailing_user.email], email.to
    assert_equal [@mailing_setting.email], email.from
    assert_equal "[#{@setting.title}] #{@mailing_message.title}", email.subject
  end

  private

  def initialize_test
    @setting = settings(:one)
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
    @mailing_setting = mailing_settings(:one).decorate
  end

  def response
    @response = ActionController::TestRequest.create
  end

  def set_opts
    {
      mailing_user: @mailing_user,
      mailing_message: @mailing_message,
      mailing_setting: @mailing_setting
    }
  end
end
