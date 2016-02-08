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
    ['testeur', 'abonné'].each do |role|
      assert roles.include?(role), "\"#{role}\" should be included in list"
    end
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag if send_welcome enabled' do
    assert_match "<span class=\"status_tag oui green\">Oui</span>", @newsletter_setting_decorated.send_welcome_email
  end

  test 'should return correct status_tag if send_welcome disabled' do
    @newsletter_setting.update_attribute(:send_welcome_email, false)
    assert_match "<span class=\"status_tag non red\">Non</span>", @newsletter_setting_decorated.send_welcome_email
  end

  private

  def initialize_test
    @newsletter_setting = newsletter_settings(:one)
    @newsletter_setting_decorated = NewsletterSettingDecorator.new(@newsletter_setting)
  end
end
