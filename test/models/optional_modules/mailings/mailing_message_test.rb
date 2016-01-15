require 'test_helper'

#
# == MailingMessage Model
#
class MailingMessageTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should be linked to correct emailing user(s)' do
    assert_includes @mailing_message.mailing_users.map(&:fullname), @mailing_user.fullname
    assert_not_includes @mailing_message.mailing_users.map(&:fullname), @mailing_user_two.fullname
  end

  test 'should not be linked anymore if message destroyed' do
    skip 'Find a way to make this test pass'
  end

  #
  # == Picture
  #
  test 'should have one picture linked' do
    assert_equal 'merry-christmas.jpg', @mailing_message.picture.image_file_name
  end

  test 'should not upload picture if mime type is not allowed' do
    [:original, :huge, :large, :medium, :small, :thumb].each do
      assert_nil @mailing_message_two.picture
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @mailing_message_two.update_attributes(picture_attributes: { image: attachment })

    [:original, :huge, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @mailing_message_two.picture.image
    end
  end

  test 'should upload picture if mime type is allowed' do
    [:original, :huge, :large, :medium, :small, :thumb].each do
      assert_nil @mailing_message_two.picture
    end

    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @mailing_message_two.update_attributes(picture_attributes: { image: attachment })

    [:original, :huge, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'background-paris.jpg', size, @mailing_message_two.picture.image
    end
  end

  private

  def initialize_test
    @mailing_message = mailing_messages(:one)
    @mailing_message_two = mailing_messages(:two)
    @mailing_user = mailing_users(:one)
    @mailing_user_two = mailing_users(:two)
  end
end
