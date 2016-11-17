# frozen_string_literal: true
require 'test_helper'

#
# MailingUser Decorator test
# ============================
class MailingUserDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # Columns
  # ==========
  test 'should return correct name for mailing user' do
    expected = "lorie@mailing.com <small>(Lorie)</small> #{@mailing_user_decorated.lang}"
    assert_equal expected, @mailing_user_decorated.name
  end

  test 'should return correct value for name_or_not method' do
    assert_equal ' Lorie,', @mailing_user_decorated.name_or_not
  end

  test 'should return correct value for name_or_not method 2' do
    @mailing_user.update_attribute(:fullname, '')
    assert_equal ',', @mailing_user_decorated.name_or_not
  end

  #
  # Status tag
  # ============
  test 'should return correct status_tag if archived' do
    @mailing_user.update_attribute(:archive, true)
    assert_match '<span class="status_tag archivé blue">Archivé</span>', @mailing_user_decorated.archive_status
  end

  test 'should return correct status_tag if not archived' do
    assert_match '<span class="status_tag non_archivé warning">Non Archivé</span>', @mailing_user_decorated.archive_status
  end

  private

  def initialize_test
    @mailing_user = mailing_users(:one)
    @mailing_user_decorated = MailingUserDecorator.new(@mailing_user)
  end
end
