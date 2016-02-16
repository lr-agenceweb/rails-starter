require 'test_helper'

#
# == MailingMessage Mailer test class
#
class MailingMessageMailerTest < ActionMailer::TestCase
  include ActionController::TemplateAssertions

  setup :initialize_test

  test 'should use correct template and layout' do
    MailingMessageMailer.send_email(@mailing_user, @mailing_message).deliver_now
    assert_template :send_email
    assert_template layout: 'mailing'
  end

  test 'should send email with default headers' do
    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    email = MailingMessageMailer.send_email(@mailing_user, @mailing_message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@mailing_user.email], email.to
    assert_equal [@setting.email], email.from
    assert_equal @mailing_message.title, email.subject
  end

  test 'should send email with custom headers' do
    @mailing_setting.update_attribute(:email, 'customemail@host.com')
    assert_equal 'customemail@host.com', @mailing_setting.email

    clear_deliveries_and_queues
    assert_no_enqueued_jobs
    assert ActionMailer::Base.deliveries.empty?

    email = MailingMessageMailer.send_email(@mailing_user, @mailing_message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@mailing_user.email], email.to
    assert_equal [@mailing_setting.email], email.from
    assert_equal @mailing_message.title, email.subject
  end

  private

  def initialize_test
    @setting = settings(:one)
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
    @mailing_setting = mailing_settings(:one)
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
