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
      sign_out @super_administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @administrator.id
      assert_redirected_to new_user_session_path
      get :edit, id: @administrator.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @super_administrator.id
      assert_response :success
    end

    test 'should destroy user' do
      assert_difference 'User.count', -1 do
        delete :destroy, id: @administrator.id
      end
      assert_redirected_to admin_users_path
    end

    #####################
    ## Superadministator
    ####################
    test 'should be able to edit super_administrator if user is superadministrator' do
      get :edit, id: @super_administrator.id
      assert_response :success

      get :edit, id: @administrator.id
      assert_response :success

      get :edit, id: @subscriber.id
      assert_response :success
    end

    test 'should be able to update super_administrator if user is super_administrator' do
      patch :update, id: @super_administrator.id, user: {}
      assert_redirected_to admin_user_path(@super_administrator)
    end

    test 'should be able to update administrator if user is superadministrator' do
      patch :update, id: @administrator.id, user: {}
      assert_redirected_to admin_user_path(@administrator)
    end

    test 'should be able to update subscriber if user is superadministrator' do
      patch :update, id: @subscriber.id, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    #####################
    ## Administrator
    ####################
    test 'should not be able to edit superadmin if user is administrator' do
      sign_out @super_administrator
      sign_in @administrator
      get :edit, id: @super_administrator.id
      assert_redirected_to admin_root_path
    end

    test 'should not be able to update superadmin if user is administrator' do
      sign_out @super_administrator
      sign_in @administrator
      patch :update, id: @super_administrator.id, user: {}
      assert_redirected_to admin_root_path
    end

    test 'should not be able to update role_id in super_administrator if administrator' do
      sign_in @administrator
      patch :update, id: @administrator.id, user: { role_id: @super_administrator.role_id }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should not be able to update role_id with incorrect id if administrator' do
      sign_in @administrator
      patch :update, id: @administrator.id, user: { role_id: '778899' }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should be able to edit subscriber if user is administrator' do
      sign_out @super_administrator
      sign_in @administrator
      get :edit, id: @subscriber.id
      assert_response :success
    end

    test 'should be able to update subscriber if user is administrator' do
      sign_out @super_administrator
      sign_in @administrator
      patch :update, id: @subscriber.id, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    test 'should be able to update role_id if user is administrator' do
      sign_in @administrator
      patch :update, id: @administrator.id, user: { role_id: @subscriber.role_id }
      assert_equal assigns(:user).role_id, @subscriber.role_id
      assert_equal assigns(:user).role_name, @subscriber.role_name
    end

    #####################
    ## Subscriber
    ####################
    test 'should not be able to edit superadmin if user is subscriber' do
      sign_in @subscriber
      get :edit, id: @super_administrator.id
      assert_redirected_to admin_user_path(@subscriber)
    end

    test 'should not be able to edit admin if user is subscriber' do
      sign_in @subscriber
      get :edit, id: @administrator.id
      assert_redirected_to admin_user_path(@subscriber)
    end

    test 'should not be able to update role_id if user is subscriber' do
      sign_in @subscriber
      patch :update, id: @subscriber.id, user: { role_id: @super_administrator.role_id }
      assert_equal assigns(:user).role_id, @subscriber.role_id
      assert_equal assigns(:user).role_name, @subscriber.role_name
    end

    test 'should be able to update itself' do
      sign_in @subscriber
      get :edit, id: @subscriber.id
      assert_response :success

      sign_in @administrator
      get :edit, id: @administrator.id
      assert_response :success

      sign_in @super_administrator
      get :edit, id: @super_administrator.id
      assert_response :success
    end

    test 'should count users' do
      assert_equal User.count, 4
    end

    private

    def initialize_test
      @super_administrator = users(:anthony)
      @administrator = users(:bob)
      @subscriber = users(:alice)
      sign_in @super_administrator
    end
  end
end
