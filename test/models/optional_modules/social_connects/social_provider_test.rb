require 'test_helper'

#
# == SocialProvider test
#
class SocialProviderTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation
  #
  test 'should save social provider if all good' do
    @facebook_provider.destroy
    social_provider = SocialProvider.new(name: 'facebook')
    assert social_provider.valid?
    assert_empty social_provider.errors.keys
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

  private

  def initialize_test
    @facebook_provider = social_providers(:facebook)
  end
end
