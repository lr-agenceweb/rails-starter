# frozen_string_literal: true
require 'test_helper'

#
# Link Model test
# =================
class LinkTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:linkable)
  should_not validate_presence_of(:url)

  should allow_value('http://test.com').for(:url)
  should_not allow_value('http://test').for(:url)

  #
  # Validation rules
  # =================
  test 'should not save if url is not correct' do
    link = Link.new url: 'bad-url'
    assert_not link.valid?
    assert_equal [:url], link.errors.keys
  end

  test 'should save if url is nil' do
    link = Link.new url: nil
    assert link.valid?
    assert_empty link.errors.keys
  end

  test 'should save if url is correct' do
    link = Link.new url: 'http://test.com'
    assert link.valid?
    assert_empty link.errors.keys
  end
end
