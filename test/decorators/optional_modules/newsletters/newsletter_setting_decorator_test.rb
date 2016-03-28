# frozen_string_literal: true
require 'test_helper'

#
# == NewsletterSettingDecorator test
#
class NewsletterSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Content
  #
  test 'should get correct email title after subscribing' do
    assert_equal 'Je suis le titre', @newsletter_setting_decorated.title_subscriber
  end

  test 'should get correct email content after subscribing' do
    assert_equal 'Je suis le contenu', @newsletter_setting_decorated.content_subscriber
  end

  test 'should get list of newsletter user roles' do
    roles = @newsletter_setting_decorated.newsletter_user_roles_list
    %w( testeur abonné ).each do |role|
      assert roles.include?(role), "\"#{role}\" should be included in list"
    end
  end

  private

  def initialize_test
    @newsletter_setting = newsletter_settings(:one)
    @newsletter_setting_decorated = NewsletterSettingDecorator.new(@newsletter_setting)
  end
end
