# frozen_string_literal: true
require 'test_helper'

#
# == Comment Mailer test class
#
class CommentMailerTest < ActionMailer::TestCase
  include ActionController::TemplateAssertions

  setup :initialize_test

  # Email sent when comment is being created
  test 'should send created email' do
    email = CommentMailer.comment_created(@comment).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@comment.decorate.email_registered_or_guest], email.from
    assert_equal [@setting.email], email.to
    assert_equal I18n.t('comment.created.email.subject', site: @setting.title, locale: I18n.default_locale), email.subject

    assert_template :send_validated_comment
    assert_template layout: [:comment]
  end

  # Email sent when comment is being signalled
  test 'should send email' do
    email = CommentMailer.send_email(@comment).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@setting.email], email.to
    assert_equal [@comment.decorate.email_registered_or_guest], email.from
    assert_equal I18n.t('comment.signalled.email.subject', site: @setting.title, locale: I18n.default_locale), email.subject

    assert_template :send_email
    assert_template layout: [:comment]
  end

  # Email sent when comment is being validated
  test 'should send validated email' do
    email = CommentMailer.send_validated_comment(@comment).deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal [@setting.email], email.from
    assert_equal [@comment.decorate.email_registered_or_guest], email.to
    assert_equal I18n.t('comment.validated.email.subject', site: @setting.title, locale: I18n.default_locale), email.subject

    assert_template :send_validated_comment
    assert_template layout: [:comment]
  end

  private

  def initialize_test
    @setting = settings(:one)
    @comment = comments(:five)
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
