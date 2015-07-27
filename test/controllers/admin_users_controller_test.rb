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
      assert_crud_actions(@administrator, new_user_session_path)
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

    #
    # == Avatar
    #
    test 'should be able to upload avatar' do
      sign_in @administrator
      upload_dropbox_paperclip_attachment

      user = assigns(:user)
      assert user.avatar?
      assert_equal 'bart.png', user.avatar_file_name
      assert_equal 'image/png', user.avatar_content_type
    end

    # test 'should delete avatar with user' do
    #   sign_in @super_administrator
    #   upload_dropbox_paperclip_attachment
    #   user = assigns(:user)
    #   delete :destroy, id: @subscriber
    # end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, User.new), 'should not be able to create'

      assert ability.can?(:read, @subscriber), 'should be able to read itself'
      assert ability.cannot?(:read, User.new), 'should not be able to read'
      assert ability.cannot?(:read, @administrator), 'should not be able to read administrator'
      assert ability.cannot?(:read, @super_administrator), 'should not be able to read super_administrator'

      assert ability.can?(:update, @subscriber), 'should be able to update itself'
      assert ability.cannot?(:update, User.new), 'should not be able to update'
      assert ability.cannot?(:update, @administrator), 'should not be able to update administrator'
      assert ability.cannot?(:update, @super_administrator), 'should not be able to update super_administrator'

      assert ability.can?(:destroy, @subscriber), 'should be able to destroy itself'
      assert ability.cannot?(:destroy, User.new), 'should not be able to destroy'
      assert ability.cannot?(:destroy, @administrator), 'should not be able to destroy administrator'
      assert ability.cannot?(:destroy, @super_administrator), 'should not be able to destroy super_administrator'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, User.new), 'should not be able to create'

      assert ability.can?(:read, @subscriber), 'should be able to read subscriber'
      assert ability.can?(:read, User.new), 'should be able to read'
      assert ability.can?(:read, @administrator), 'should be able to read itself'
      assert ability.can?(:read, @administrator_2), 'should be able to read other administrator'
      assert ability.cannot?(:read, @super_administrator), 'should not be able to read super_administrator'

      assert ability.can?(:update, @subscriber), 'should be able to update subscriber'
      assert ability.cannot?(:update, User.new), 'should not be able to update'
      assert ability.can?(:update, @administrator), 'should be able to update itself'
      assert ability.cannot?(:update, @administrator_2), 'should not be able to update other administrator'
      assert ability.cannot?(:update, @super_administrator), 'should not be able to update super_administrator'

      assert ability.can?(:destroy, @subscriber), 'should be able to destroy subscriber'
      assert ability.cannot?(:destroy, User.new), 'should not be able to destroy'
      assert ability.can?(:destroy, @administrator), 'should be able to destroy itself'
      assert ability.cannot?(:destroy, @administrator_2), 'should not be able to destroy other administrator'
      assert ability.cannot?(:destroy, @super_administrator), 'should not be able to destroy super_administrator'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, User.new), 'should be able to create'

      assert ability.can?(:read, @subscriber), 'should be able to read subscriber'
      assert ability.can?(:read, User.new), 'should be able to read'
      assert ability.can?(:read, @administrator), 'should be able to read itself'
      assert ability.can?(:read, @super_administrator), 'should be able to read itself'
      assert ability.can?(:read, @super_administrator_2), 'should be able to read other super_administrator'

      assert ability.can?(:update, @subscriber), 'should be able to update subscriber'
      assert ability.can?(:update, User.new), 'should not be able to update'
      assert ability.can?(:update, @administrator), 'should be able to update administrator'
      assert ability.can?(:update, @super_administrator), 'should be able to update itself'
      assert ability.cannot?(:update, @super_administrator_2), 'should not be able to update other super_administrator'

      assert ability.can?(:destroy, @subscriber), 'should be able to destroy subscriber'
      assert ability.can?(:destroy, User.new), 'should not be able to destroy'
      assert ability.can?(:destroy, @administrator), 'should be able to destroy administrator'
      assert ability.can?(:destroy, @super_administrator), 'should be able to destroy itself'
      assert ability.cannot?(:destroy, @super_administrator_2), 'should not be able to destroy other super_administrator'
    end

    private

    def initialize_test
      @subscriber = users(:alice)
      @administrator = users(:bob)
      @administrator_2 = users(:lorie)
      @super_administrator = users(:anthony)
      @super_administrator_2 = users(:maria)
      sign_in @administrator
    end

    def upload_dropbox_paperclip_attachment
      puts '=== Uploading avatar to Dropbox'
      attachment = fixture_file_upload 'images/bart.png', 'image/png'
      patch :update, id: @administrator, user: { avatar: attachment }
    end

    def remove_dropbox_paperclip_attachment(user)
      puts '=== Removing avatar from Dropbox'
      patch :update, id: user, user: { avatar: nil, delete_avatar: '1' }
      assert_not assigns(:user).avatar?
    end
  end
end
