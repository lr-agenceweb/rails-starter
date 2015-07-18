require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == SettingsController test
  #
  class SettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @setting.id
      assert_redirected_to new_user_session_path
      get :edit, id: @setting.id
      assert_redirected_to new_user_session_path
    end

    test 'should redirect index page to show if logged in' do
      get :index
      assert_redirected_to admin_setting_path(@setting)
    end

    test 'should show show page if logged in' do
      get :show, id: @setting.id
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @setting.id
      assert_response :success
    end

    test 'should update setting if logged in' do
      patch :update, id: @setting.id, setting: {}
      assert_redirected_to admin_setting_path(@setting)
    end

    #
    # == Form validations
    #
    test 'should not update article without name' do
      patch :update, id: @setting.id
      assert_not @setting.update(name: nil)
    end

    test 'should not update article without title' do
      patch :update, id: @setting.id
      assert_not @setting.update(title: nil)
    end

    #
    # == Avatar
    #
    # test 'should be able to upload logo' do
    #   upload_dropbox_paperclip_attachment
    #   setting = assigns(:setting)
    #   assert setting.logo?
    #   assert_equal 'bart.png', setting.logo_file_name
    #   assert_equal 'image/png', setting.logo_content_type
    # end

    # test 'should be able to destroy logo' do
    #   upload_dropbox_paperclip_attachment
    #   remove_dropbox_paperclip_attachment
    # end

    private

    def initialize_test
      @setting = settings(:one)
      @administrator = users(:bob)
      sign_in @administrator
    end

    def upload_dropbox_paperclip_attachment
      puts '=== Uploading logo to Dropbox'
      attachment = fixture_file_upload 'images/bart.png', 'image/png'
      patch :update, id: @setting, setting: { logo: attachment }
    end

    def remove_dropbox_paperclip_attachment
      puts '=== Removing logo from Dropbox'
      patch :update, id: @setting, setting: { logo: nil, delete_logo: '1' }
      assert_not assigns(:setting).logo?
    end
  end
end
