# frozen_string_literal: true
require 'test_helper'

#
# == ContactForm Mailer test class
#
class ContactFormMailerTest < ActionMailer::TestCase
  include HtmlHelper
  include ActionController::TemplateAssertions
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Send email
  #
  test 'should message me' do
    email = ContactFormMailer.message_me(@message).deliver_now
    refute ActionMailer::Base.deliveries.empty?
    last_email = ActionMailer::Base.deliveries.last

    #
    # Headers and content
    # ===================
    assert_equal ['cristiano@ronaldo.pt'], email.from
    assert_equal ['demo@rails-starter.com'], email.to
    assert_equal I18n.t('contact_form_mailer.message_me.subject', site: @setting.title), email.subject
    assert_match(/Hello from the internet/, last_email.text_part.body.to_s)
    assert_match(/Hello from the internet/, last_email.html_part.body.to_s)

    #
    # Template
    # ========
    assert_template :message_me
    assert_template layout: 'mailers/default'

    ActionMailer::Base.deliveries.clear
  end

  test 'should send copy of email contact to sender' do
    ContactFormMailer.message_me(@message).deliver_now
    ContactFormMailer.send_copy(@message).deliver_now
    refute ActionMailer::Base.deliveries.empty?
    contact_email = ActionMailer::Base.deliveries.first
    cc_email = ActionMailer::Base.deliveries.last

    #
    # Headers and content
    # ===================
    # Contact => Admin
    assert_equal 'cristiano@ronaldo.pt', contact_email.from[0]
    assert_equal 'demo@rails-starter.com', contact_email.to[0]
    assert_equal I18n.t('contact_form_mailer.message_me.subject', site: @setting.title, locale: I18n.default_locale), contact_email.subject
    assert_match(/Hello from the internet/, contact_email.text_part.body.to_s)
    assert_match(/Hello from the internet/, contact_email.html_part.body.to_s)

    # Admin => Contact (Carbon Copy)
    assert_equal 'demo@rails-starter.com', cc_email.from[0]
    assert_equal 'cristiano@ronaldo.pt', cc_email.to[0]
    assert_equal I18n.t('contact_form_mailer.send_copy.subject', site: @setting.title, locale: I18n.default_locale), cc_email.subject
    assert_match(/Hello from the internet/, cc_email.text_part.body.to_s)
    assert_match(/Hello from the internet/, cc_email.html_part.body.to_s)

    #
    # Template
    # ========
    assert_template :message_me
    assert_template layout: 'mailers/default'

    ActionMailer::Base.deliveries.clear
  end

  #
  # == AnsweringMachine
  #
  test 'should send answering machine email to sender' do
    email = ContactFormMailer.answering_machine('karim@benzema.fr').deliver_now

    refute ActionMailer::Base.deliveries.empty?
    assert_equal ['demo@rails-starter.com'], email.from
    assert_equal ['karim@benzema.fr'], email.to

    assert_template :answering_machine
    assert_template layout: 'mailers/default'
  end

  test 'should use correct string box answering machine content if defined' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        email = ContactFormMailer.answering_machine('karim@benzema.fr', locale).deliver_now
        last_email = ActionMailer::Base.deliveries.last

        assert_equal @answering_machine.title, email.subject
        content = sanitize_string(@answering_machine.content)
        assert_match(/#{content}/, CGI.unescape_html(last_email.text_part.body.to_s))
        assert_match(/#{content}/, sanitize_string(last_email.html_part.body.to_s))

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should use default answering machine title and content if string box not defined' do
    @answering_machine.destroy
    @locales.each do |locale|
      I18n.with_locale(locale) do
        email = ContactFormMailer.answering_machine('karim@benzema.fr', locale).deliver_now
        last_email = ActionMailer::Base.deliveries.last

        assert_equal I18n.t('contact_form_mailer.answering_machine.subject', site: @setting.title, locale: locale), email.subject
        content = sanitize_string(I18n.t('contact_form_mailer.answering_machine.content'))
        assert_match(/#{content}/, CGI.unescape_html(last_email.text_part.body.to_s))
        assert_match(/#{content}/, sanitize_string(last_email.html_part.body.to_s))

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should use default answering machine subject if string box defined but with empty title' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        @answering_machine.update_attribute(:title, '')
        email = ContactFormMailer.answering_machine('karim@benzema.fr', locale).deliver_now

        assert_equal I18n.t('contact_form_mailer.answering_machine.subject', site: @setting.title, locale: locale), email.subject

        ActionMailer::Base.deliveries.clear
      end
    end
  end

  test 'should use default answering machine content if string box defined but with empty content' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        @answering_machine.update_attribute(:content, '')
        ContactFormMailer.answering_machine('karim@benzema.fr', locale).deliver_now
        last_email = ActionMailer::Base.deliveries.last

        content = sanitize_string(I18n.t('contact_form_mailer.answering_machine.content'))
        assert_match(/#{content}/, CGI.unescape_html(last_email.text_part.body.to_s))
        assert_match(/#{content}/, sanitize_string(last_email.html_part.body.to_s))

        ActionMailer::Base.deliveries.clear
      end
    end
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
    @locales = I18n.available_locales

    @message = ContactForm.new(
      name: 'cristiano',
      email: 'cristiano@ronaldo.pt',
      message: 'Hello from the internet'
    )
    @answering_machine = string_boxes(:answering_machine)
  end

  def response
    @response = ActionController::TestRequest.new(host: 'http://test.host')
  end
end
