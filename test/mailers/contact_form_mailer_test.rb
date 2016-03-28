# frozen_string_literal: true
require 'test_helper'

#
# == ContactForm Mailer test class
#
class ContactFormMailerTest < ActionMailer::TestCase
  setup :initialize_test

  test 'should message me' do
    email = ContactFormMailer.message_me(@message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['demo@rails-starter.com'], email.to
    assert_equal ['cristiano@ronaldo.pt'], email.from
    assert_equal 'Message envoyé par le site Rails Starter', email.subject
    # assert_equal 'Hello from the internet', email.text_part.body.to_s
    # assert_equal 'Hello from the internet', email.html_part.body.to_s
  end

  test 'should send copy of email contact to sender' do
    email = ContactFormMailer.send_copy(@message).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['cristiano@ronaldo.pt'], email.to
    assert_equal ['demo@rails-starter.com'], email.from
    assert_equal 'Copie de votre message de contact envoyé à Rails Starter', email.subject
    # assert_equal 'Hello from the internet', email.text_part.body.to_s
    # assert_equal 'Hello from the internet', email.html_part.body.to_s
  end

  private

  def initialize_test
    @message = ContactForm.new(
      name: 'cristiano',
      email: 'cristiano@ronaldo.pt',
      message: 'Hello from the internet'
    )
  end
end
