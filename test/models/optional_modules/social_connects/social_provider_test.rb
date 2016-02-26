require 'test_helper'
require 'minitest/autorun'

#
# == SocialProvider test
#
class SocialProviderTest < ActiveSupport::TestCase
  setup :initialize_test

  ENV['facebook_app_id'] = '123'
  ENV['facebook_app_secret'] = '123'

  #
  # == Validation
  #
  test 'should save social provider if all good' do
    @facebook_provider.destroy
    social_provider = SocialProvider.new(name: 'facebook')
    assert social_provider.valid?
    assert_empty social_provider.errors.keys
  end

  test 'should not save social provider if env keys are not set' do
    skip 'Find a way to stub env variable'
    ENV.stub(:[]).with(:facebook_app_id).returns(nil)
    ENV.stub(:[]).with(:facebook_app_secret).returns(nil)
    @facebook_provider.destroy
    social_provider = SocialProvider.new(name: 'facebook')
    assert_not social_provider.valid?
    assert_equal [:name], social_provider.errors.keys
  end

  test 'should not save social provider if not unique' do
    social_provider = SocialProvider.new(name: 'facebook')
    assert_not social_provider.valid?
    assert_equal [:name], social_provider.errors.keys
  end

  test 'should not save social provider if not allowed' do
    social_provider = SocialProvider.new(name: 'Linkedin')
    assert_not social_provider.valid?
    assert_equal [:name], social_provider.errors.keys
  end

  #
  # == Methods
  #
  test 'should return correct social provider by name' do
    assert_equal @facebook_provider, SocialProvider.provider_by_name('facebook')
    assert_nil SocialProvider.provider_by_name('Linkedin')
  end

  test 'should allow social connect if all enabled' do
    assert SocialProvider.allowed_to_use?
  end

  test 'should not allow social connect if social_connect_module disabled' do
    @social_connect_module.update_attribute(:enabled, false)
    assert_not SocialProvider.allowed_to_use?
  end

  test 'should not allow social connect if social_connect_setting disabled' do
    @social_connect_setting.update_attribute(:enabled, false)
    assert_not SocialProvider.allowed_to_use?
  end

  private

  def initialize_test
    @facebook_provider = social_providers(:facebook)
    @social_connect_module = optional_modules(:social_connect)
    @social_connect_setting = social_connect_settings(:one)
  end
end
