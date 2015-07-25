require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == UsersController test
  #
  class UsersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @administrator
      assert_redirected_to new_user_session_path
      get :edit, id: @administrator
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @administrator
      assert_response :success
    end

    test 'should destroy user' do
      assert_difference 'User.count', -1 do
        delete :destroy, id: @administrator
      end
      assert_redirected_to admin_users_path
    end

    #####################
    ## Superadministator
    ####################
    test 'should be able to create user' do
      sign_in @super_administrator
      assert_difference 'User.count' do
        post :create, user: { username: 'Marco', email: 'marco@test.com', password: 'password', confirm_password: 'password' }
      end
    end

    test 'should not be able to create user if username is already taken' do
      sign_in @super_administrator
      assert_no_difference 'User.count' do
        post :create, user: { username: 'bob', email: 'bob@test.fr', password: 'password', confirm_password: 'password' }
      end
      assert_not assigns(:user).valid?
    end

    test 'should not be able to create user if username is already taken (case_sensitive)' do
      sign_in @super_administrator
      assert_no_difference 'User.count' do
        post :create, user: { username: 'Bob', email: 'bob@test.fr', password: 'password', confirm_password: 'password' }
      end
      assert_not assigns(:user).valid?
    end

    test 'should be able to edit super_administrator if user is superadministrator' do
      sign_in @super_administrator

      get :edit, id: @super_administrator
      assert_response :success
      get :edit, id: @administrator
      assert_response :success
      get :edit, id: @subscriber
      assert_response :success
    end

    test 'should be able to update super_administrator if user is super_administrator' do
      sign_in @super_administrator
      patch :update, id: @super_administrator, user: {}
      assert_redirected_to admin_user_path(@super_administrator)
    end

    test 'should be able to update administrator if user is superadministrator' do
      sign_in @super_administrator
      patch :update, id: @administrator, user: {}
      assert_redirected_to admin_user_path(@administrator)
    end

    test 'should be able to update subscriber if user is superadministrator' do
      sign_in @super_administrator
      patch :update, id: @subscriber, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    #####################
    ## Administrator
    ####################
    test 'should not be able to create user if administrator' do
      assert_no_difference 'User.count' do
        post :create, user: { username: 'Marco', email: 'marco@test.com', password: 'password', confirm_password: 'password' }
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit superadmin if user is administrator' do
      get :edit, id: @super_administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to update superadmin if user is administrator' do
      patch :update, id: @super_administrator, user: {}
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to update role_id in super_administrator if administrator' do
      patch :update, id: @administrator, user: { role_id: @super_administrator.role_id }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should not be able to update role_id with incorrect id if administrator' do
      patch :update, id: @administrator, user: { role_id: '778899' }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should be able to edit subscriber if user is administrator' do
      get :edit, id: @subscriber
      assert_response :success
    end

    test 'should be able to update subscriber if user is administrator' do
      patch :update, id: @subscriber, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    test 'should be able to update role_id if user is administrator' do
      patch :update, id: @administrator, user: { role_id: @subscriber.role_id }
      assert_equal assigns(:user).role_id, @subscriber.role_id
      assert_equal assigns(:user).role_name, @subscriber.role_name
    end

    #####################
    ## Subscriber
    ####################
    test 'should not be able to create user if subscriber' do
      sign_in @subscriber
      assert_no_difference 'User.count' do
        post :create, user: { username: 'Marco', email: 'marco@test.com', password: 'password', confirm_password: 'password' }
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit superadmin if user is subscriber' do
      sign_in @subscriber
      get :edit, id: @super_administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit admin if user is subscriber' do
      sign_in @subscriber
      get :edit, id: @administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to update role_id if user is subscriber' do
      sign_in @subscriber
      patch :update, id: @subscriber, user: { role_id: @super_administrator.role_id }
      assert_equal assigns(:user).role_id, @subscriber.role_id
      assert_equal assigns(:user).role_name, @subscriber.role_name
    end

    test 'should be able to update itself' do
      sign_in @subscriber
      get :edit, id: @subscriber
      assert_response :success

      sign_in @administrator
      get :edit, id: @administrator
      assert_response :success

      sign_in @super_administrator
      get :edit, id: @super_administrator
      assert_response :success
    end

    test 'should count users' do
      assert_equal User.count, 4
    end

    #
    # == Avatar
    #
    # test 'should be able to upload avatar' do
    #   sign_in @administrator
    #   upload_dropbox_paperclip_attachment

    #   user = assigns(:user)
    #   assert user.avatar?
    #   assert_equal 'bart.png', user.avatar_file_name
    #   assert_equal 'image/png', user.avatar_content_type

    #   remove_dropbox_paperclip_attachment(user)
    # end

    # test 'should delete avatar with user' do
    #   sign_in @super_administrator
    #   attachment = fixture_file_upload 'images/homer.png', 'image/png'
    #   puts '=== Uploading attachment to Dropbox'
    #   patch :update, id: @subscriber, user: { avatar: attachment }
    #   user = assigns(:user)
    #   delete :destroy, id: @subscriber
    # end

    private

    def initialize_test
      @super_administrator = users(:anthony)
      @administrator = users(:bob)
      @subscriber = users(:alice)
      sign_in @administrator
    end

    def upload_dropbox_paperclip_attachment
      puts '=== Uploading avatar to Dropbox'
      attachment = fixture_file_upload 'images/bart.png', 'image/png'
      patch :update, id: @user, user: { avatar: attachment }
    end

    def remove_dropbox_paperclip_attachment(user)
      puts '=== Removing avatar from Dropbox'
      patch :update, id: user, user: { avatar: nil, delete_avatar: '1' }
      assert_not assigns(:user).avatar?
    end
  end
end
