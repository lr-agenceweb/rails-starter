require 'test_helper'

#
# == Comment Mailer test class
#
class CommentMailerTest < ActionMailer::TestCase
  setup :initialize_test

  test 'should send email' do
    email = CommentMailer.send_email(@comment).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@setting.email], email.to
    assert_equal [@comment.decorate.email_registered_or_guest], email.from
    assert_equal I18n.t('comment.signalled.email.subject', site: @setting.title, locale: I18n.default_locale), email.subject
  end

  private

  def initialize_test
    @setting = settings(:one)
    @comment = comments(:five)
  end
end
