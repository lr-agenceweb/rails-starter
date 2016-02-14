
require 'test_helper'

#
# == CommentSettingDecorator test
#
class CommentSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Status tag
  #
  test 'should return correct status_tag if should validate' do
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag oui green">Oui</span>', comment_setting_decorated.should_validate
  end

  test 'should return correct status_tag if should not validate' do
    @comment_setting.update_attribute(:should_validate, false)
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag non red">Non</span>', comment_setting_decorated.should_validate
  end

  test 'should return correct status_tag if should signal' do
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag oui green">Oui</span>', comment_setting_decorated.should_signal
  end

  test 'should return correct status_tag if should not signal' do
    @comment_setting.update_attribute(:should_signal, false)
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag non red">Non</span>', comment_setting_decorated.should_signal
  end

  test 'should return correct status_tag if send email' do
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag oui green">Oui</span>', comment_setting_decorated.send_email
  end

  test 'should return correct status_tag if don\'t send email' do
    @comment_setting.update_attribute(:send_email, false)
    comment_setting_decorated = CommentSettingDecorator.new(@comment_setting)
    assert_match '<span class="status_tag non red">Non</span>', comment_setting_decorated.send_email
  end

  private

  def initialize_test
    @comment_setting = comment_settings(:one)
  end
end
