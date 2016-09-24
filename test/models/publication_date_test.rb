# frozen_string_literal: true
require 'test_helper'

#
# == PublicationDate Model test
#
class PublicationDateTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Published later / Expired prematurely
  #
  test 'should reset published_at to null if boolean is not checked' do
    assert_equal '2028-03-11 09:00:00', @published_later.published_at.to_s(:db)
    @published_later.update_attribute(:published_later, false)
    assert_nil @published_later.reload.published_at
  end

  test 'should reset expired_at to null if boolean is not checked' do
    assert_equal '2028-12-27 21:00:00', @published_later.expired_at.to_s(:db)
    @published_later.update_attribute(:expired_prematurely, false)
    assert_nil @published_later.reload.expired_at
  end

  test 'should not reset published_at / expired_at if boolean still checked' do
    @published_later.save
    assert_not_nil @published_later.reload.expired_at
    assert_not_nil @published_later.reload.published_at
  end

  private

  def initialize_test
    @published_later = publication_dates(:one)
  end
end
