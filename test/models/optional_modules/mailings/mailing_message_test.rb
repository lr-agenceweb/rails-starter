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
    assert_not @mailing_user_two.mailing_messages.empty?, 'user should be link to message'
    @mailing_message_two.destroy
    assert @mailing_message_two.destroyed?
    assert @mailing_user_two.mailing_messages.empty?, 'user should not be link to message'
  end

  #
  # == Should redirect
  #
  test 'should return correct value for redirect_to_form? if new record' do
    mailing_message = MailingMessage.new
    mailing_message.save!
    assert_not mailing_message.should_redirect
  end

  test 'should return correct value for redirect_to_form? if new record and adding picture' do
    mailing_message = MailingMessage.new
    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    mailing_message.update_attributes(picture_attributes: { image: attachment })
    mailing_message.save!
    assert mailing_message.should_redirect
  end

  test 'should return correct value for redirect_to_form? if adding picture' do
    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @mailing_message_two.update_attributes(picture_attributes: { image: attachment })
    @mailing_message_two.save!
    assert @mailing_message_two.should_redirect
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
