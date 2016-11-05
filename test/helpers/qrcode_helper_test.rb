# frozen_string_literal: true
require 'test_helper'

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == QrcodeHelper Test
  #
  class QrcodeHelperTest < ActionView::TestCase
    include Rails.application.routes.url_helpers

    setup :initialize_test

    test 'should return correct value for set_name' do
      assert_equal "N:Rails Starter\nFN:Rails Starter\n", set_name
    end

    test 'should return correct value for set_phone' do
      assert_equal "TEL;WORK:+33 (0)1 02 03 04 05\n", set_phone
    end

    test 'should return correct value for set_address' do
      assert_equal "ADR;WORK:;;1 Main Street;Auckland;;06001;France\n", set_address
    end

    test 'should return correct value for set_organization' do
      assert_equal "ORG:Rails Starter démarre rapidement\n", set_organization
    end

    test 'should return correct value for set_email' do
      assert_equal "EMAIL:demo@rails-starter.com\n", set_email
    end

    test 'should return correct value for set_url' do
      assert_equal "URL:#{root_url}\n", set_url
    end

    test 'should return correct value for vcard' do
      assert_equal @vcard_string, vcard
    end

    test 'should return correct value for qrcode_base_url' do
      assert_equal "http://chart.apis.google.com/chart?chs=200x200&cht=qr&chl=#{u @vcard_string}", qrcode_base_url(200)
    end

    test 'should return correct value for qrcode_image_tag' do
      assert_equal "<img alt=\"QrCode\" src=\"http://chart.apis.google.com/chart?chs=100x100&amp;cht=qr&amp;chl=#{u @vcard_string}\" />", qrcode_image_tag(100)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @map_setting = map_settings(:one)

      @vcard_string = "BEGIN:VCARD\nVERSION:3.0\nN:Rails Starter\nFN:Rails Starter\nTEL;WORK:+33 (0)1 02 03 04 05\nADR;WORK:;;1 Main Street;Auckland;;06001;France\nORG:Rails Starter démarre rapidement\nEMAIL:demo@rails-starter.com\nURL:http://test.host/\nEND:VCARD"
    end
  end
end
