# frozen_string_literal: true
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

    #
    # == Routes / Templates
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@administrator, new_user_session_path, model_name)
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

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_active batch action' do
      post :batch_action, batch_action: 'toggle_active', collection_selection: [@administrator_2.id, @bart.id]
      [@administrator_2, @bart].each(&:reload)
      assert_not @administrator_2.account_active?
      assert @bart.account_active?
    end

    test 'should not toggle_active current user in batch action' do
      post :batch_action, batch_action: 'toggle_active', collection_selection: [@administrator.id]
      [@administrator].each(&:reload)
      assert @administrator.account_active?
    end

    test 'should not toggle_active super_administrator by administrator in batch action' do
      post :batch_action, batch_action: 'toggle_active', collection_selection: [@super_administrator.id]
      [@super_administrator].each(&:reload)
      assert @super_administrator.account_active?
    end

    test 'should redirect to back and have correct flash notice for toggle_active batch action' do
      post :batch_action, batch_action: 'toggle_active', collection_selection: [@administrator_2.id]
      assert_redirected_to admin_users_path
      assert_equal I18n.t('active_admin.batch_actions.toggle_active'), flash[:notice]
    end

    test 'should send correct number of email after activating user account by batch action' do
      post :batch_action, batch_action: 'toggle_active', collection_selection: [@administrator_2.id, @bart.id]
      [@administrator_2, @bart].each(&:reload)
      assert_enqueued_jobs 1
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, batch_action: 'reset_cache', collection_selection: [@bart.id]
      assert_redirected_to admin_users_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # == Account validation
    #
    test 'should not be able to sign in if account is not active' do
      sign_in @bart
      get :show, id: @bart
      assert_redirected_to new_user_session_path
      assert_equal I18n.t('devise.failure.inactive'), flash[:alert]
    end

    test 'should be able to sign in if account is active' do
      @bart.update_attribute(:account_active, true)
      sign_in @bart
      get :show, id: @bart
      assert_response :success
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

    test 'should not be able to create if username already taken' do
      sign_in @super_administrator
      assert_no_difference 'User.count' do
        post :create, user: { username: 'bob', email: 'bob@test.fr', password: 'password', confirm_password: 'password' }
      end
      assert_not assigns(:user).valid?
    end

    test 'should not be able to create if username taken (CS)' do
      # CS = Case Sensitive
      sign_in @super_administrator
      assert_no_difference 'User.count' do
        post :create, user: { username: 'Bob', email: 'bob@test.fr', password: 'password', confirm_password: 'password' }
      end
      assert_not assigns(:user).valid?
    end

    test 'should be able to edit super_administrator if user is SA' do
      sign_in @super_administrator

      get :edit, id: @super_administrator
      assert_response :success
      get :edit, id: @administrator
      assert_response :success
      get :edit, id: @subscriber
      assert_response :success
    end

    test 'should be able to update itself if user is SA' do
      sign_in @super_administrator
      patch :update, id: @super_administrator, user: {}
      assert_redirected_to admin_user_path(@super_administrator)
    end

    test 'should be able to update administrator if user is SA' do
      sign_in @super_administrator
      patch :update, id: @administrator, user: {}
      assert_redirected_to admin_user_path(@administrator)
    end

    test 'should be able to update subscriber if user is SA' do
      sign_in @super_administrator
      patch :update, id: @subscriber, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    #####################
    ## Administrator
    ####################
    test 'should not be able to create user if admin' do
      assert_no_difference 'User.count' do
        post :create, user: { username: 'Marco', email: 'marco@test.com', password: 'password', confirm_password: 'password' }
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit SA if user is admin' do
      get :edit, id: @super_administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to update SA if user is admin' do
      patch :update, id: @super_administrator, user: {}
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to update role_id in SA if admin' do
      patch :update, id: @administrator, user: { role_id: @super_administrator.role_id }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should not be able to update role_id if wrong id and admin' do
      patch :update, id: @administrator, user: { role_id: '778899' }
      assert_equal assigns(:user).role_id, @administrator.role_id
      assert_equal assigns(:user).role_name, @administrator.role_name
    end

    test 'should be able to edit subscriber if user is admin' do
      get :edit, id: @subscriber
      assert_response :success
    end

    test 'should be able to update subscriber if user is admin' do
      patch :update, id: @subscriber, user: {}
      assert_redirected_to admin_user_path(@subscriber)
    end

    test 'should be able to update role_id if user is admin' do
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

    test 'should not be able to edit SA if user is subscriber' do
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
      upload_paperclip_attachment

      user = assigns(:user)
      assert user.avatar?
      assert_equal 'bart.png', user.avatar_file_name
      assert_equal 'image/png', user.avatar_content_type
    end

    test 'should delete avatar with user' do
      sign_in @super_administrator
      upload_paperclip_attachment
      user = assigns(:user)

      delete :destroy, id: user
      assert_not user.avatar?
      assert user.avatar_file_name.blank?
      assert user.avatar_content_type.blank?
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend
    end

    test 'should render maintenance if enabled and subscriber' do
      sign_in @subscriber
      assert_maintenance_backend
      assert_response :success
    end

    test 'should redirect to login if maintenance and not connected' do
      sign_out @administrator
      assert_maintenance_backend
      assert_redirected_to new_user_session_path
    end

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

      assert ability.cannot?(:reset_cache, @subscriber), 'should not be able to reset_cache batch_action'
      assert ability.cannot?(:toggle_active, @subscriber), 'should not be able to toggle_active itself'
      assert ability.cannot?(:toggle_active, @administrator), 'should not be able to toggle_active administrator'
      assert ability.cannot?(:toggle_active, @super_administrator), 'should not be able to toggle_active super_administrator'
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

      assert ability.can?(:reset_cache, @subscriber), 'should be able to reset_cache batch_action'
      assert ability.can?(:toggle_active, @subscriber), 'should be able to toggle_active batch_action'
      assert ability.cannot?(:toggle_active, @administrator), 'should not be able to toggle_active itslef'
      assert ability.cannot?(:toggle_active, @administrator_2), 'should not be able to toggle_active other administrator'
      assert ability.cannot?(:toggle_active, @super_administrator), 'should not be able to toggle_active super_administrator'
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

      assert ability.can?(:reset_cache, @subscriber), 'should be able to reset_cache batch_action'
      assert ability.can?(:toggle_active, @subscriber), 'should be able to toggle_active batch_action'
      assert ability.can?(:toggle_active, @administrator), 'should be able to toggle_active administrator'
      assert ability.cannot?(:toggle_active, @super_administrator), 'should not be able to toggle_active itself'
      assert ability.cannot?(:toggle_active, @super_administrator_2), 'should not be able to toggle_active other super_administrator'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_users_path

      @bart = users(:bart)
      @subscriber = users(:alice)
      @administrator = users(:bob)
      @administrator_2 = users(:lorie)
      @super_administrator = users(:anthony)
      @super_administrator_2 = users(:maria)

      sign_in @administrator
    end

    def upload_paperclip_attachment
      # puts '=== Uploading avatar'
      attachment = fixture_file_upload 'images/bart.png', 'image/png'
      patch :update, id: @administrator, user: { avatar: attachment }
    end

    def remove_paperclip_attachment(user)
      # puts '=== Removing avatar'
      patch :update, id: user, user: { avatar: nil, delete_avatar: '1' }
      assert_not assigns(:user).avatar?
    end
  end
end
