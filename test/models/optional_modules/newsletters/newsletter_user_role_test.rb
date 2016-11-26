# frozen_string_literal: true
require 'test_helper'

#
# NewsletterUserRole test
# =========================
class NewsletterUserRoleTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:rollable)
  should have_many(:newsletter_users)

  # should validate_presence_of(:'translations.title')
  should validate_presence_of(:kind)

  should validate_inclusion_of(:kind)
    .in_array(NewsletterUserRole.allowed_newsletter_user_roles)

  #
  # Validation rules
  # ==================
  test 'should not save if all good' do
    nur = NewsletterUserRole.new(kind: 'tester')
    assert nur.valid?
    assert nur.errors.keys.empty?
  end

  test 'should not save if kind is not set' do
    nur = NewsletterUserRole.new(kind: 'bad_value')
    assert_not nur.valid?
    assert_equal [:kind], nur.errors.keys
  end

  test 'should not save if kind is not allowed' do
    nur = NewsletterUserRole.new(kind: 'bad_value')
    assert_not nur.valid?
    assert_equal [:kind], nur.errors.keys
  end
end
