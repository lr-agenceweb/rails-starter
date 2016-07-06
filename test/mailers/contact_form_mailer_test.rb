# frozen_string_literal: true
require 'test_helper'

#
# == ContactForm Mailer test class
#
class ContactFormMailerTest < ActionMailer::TestCase
  include ActionController::TemplateAssertions
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Send email
  #
  test 'should message me' do
    email = ContactFormMailer.message_me(@message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['demo@rails-starter.com'], email.to
    assert_equal ['cristiano@ronaldo.pt'], email.from
    assert_equal I18n.t('contact_form_mailer.message_me.subject', site: @setting.title), email.subject

    assert_template :message_me
    assert_template layout: 'mailers/default'
  end

  test 'should send copy of email contact to sender' do
    email = ContactFormMailer.send_copy(@message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['cristiano@ronaldo.pt'], email.to
    assert_equal ['demo@rails-starter.com'], email.from
    assert_equal I18n.t('contact_form_mailer.send_copy.subject', site: @setting.title), email.subject

    assert_template :message_me
    assert_template layout: 'mailers/default'
  end

  #
  # == Attachment
  #
  test 'should not attach file if input is disabled' do
    @message.attachment = fixture_file_upload('/images/bart.png')
    assert_not @message.attachment.blank?

    email = ContactFormMailer.message_me(@message).deliver_now
    assert_equal 0, email.attachments.size
    assert email.attachments.blank?
  end

  test 'should attach file if input is enabled' do
    @setting.update_attribute(:show_file_upload, true)
    @message.attachment = fixture_file_upload('/images/bart.png')
    assert_not @message.attachment.blank?

    email = ContactFormMailer.message_me(@message).deliver_now
    assert_equal 1, email.attachments.size
    assert_equal 'bart.png', email.attachments[0].filename
  end

  private

  def initialize_test
    @setting = settings(:one)
    @message = ContactForm.new(
      name: 'cristiano',
      email: 'cristiano@ronaldo.pt',
      message: 'Hello from the internet'
    )
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
