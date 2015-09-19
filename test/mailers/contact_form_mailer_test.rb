require 'test_helper'

class ContactFormMailerTest < ActionMailer::TestCase
  test 'should message me' do
    msg = ContactForm.new(
      name: 'cristiano',
      email: 'cristiano@ronaldo.pt',
      message: 'Hello from the internet'
    )
    email = ContactFormMailer.message_me(msg).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['demo@rails-starter.com'], email.to
    assert_equal ['cristiano@ronaldo.pt'], email.from
    assert_equal 'Hello from the internet', email.body.to_s
  end
end