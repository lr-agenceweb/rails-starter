# frozen_string_literal: true
require 'test_helper'

#
# SocialProvider test
# =====================
class SocialProviderTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:social_connect_setting)
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  #
  # Validation rules
  # ==================
  test 'should save social provider if all good' do
    @facebook_provider.destroy
    social_provider = SocialProvider.new(name: 'facebook')
    assert social_provider.valid?, 'should be valid'
    assert_empty social_provider.errors.keys
  end

  test 'should not save social provider if env keys are not set' do
    skip 'Find a way to stub env variable'
    @facebook_provider.destroy
    ENV.stub(:facebook_app_id, nil) do
      social_provider = SocialProvider.new(name: 'facebook')
      assert_not social_provider.valid?, 'should not be valid'
      assert_equal [:name], social_provider.errors.keys
    end
  end

  test 'should not save social provider if not unique' do
    social_provider = SocialProvider.new(name: 'facebook')
    assert_not social_provider.valid?, 'should not be valid'
    assert_equal [:name], social_provider.errors.keys
  end

  test 'should not save social provider if not allowed' do
    social_provider = SocialProvider.new(name: 'Linkedin')
    assert_not social_provider.valid?, 'should not be valid'
    assert_equal [:name], social_provider.errors.keys
  end

  #
  # Methods
  # =========
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
