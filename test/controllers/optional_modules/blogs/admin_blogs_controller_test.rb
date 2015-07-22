require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == BlogsController test
  #
  class BlogsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @bob
      get :index, id: @blog
      assert_redirected_to new_user_session_path
      get :show, id: @blog
      assert_redirected_to new_user_session_path
      delete :destroy, id: @blog
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @blog
      assert_response :success
    end

    test 'should destroy blog' do
      assert_difference ['Blog.count'], -1 do
        delete :destroy, id: @blog
      end
      assert_redirected_to admin_blogs_path
    end

    private

    def initialize_test
      @request.env['HTTP_REFERER'] = admin_blogs_path
      @blog = blogs(:blog_online)
      @blog_not_validate = blogs(:blog_offline)
      @anthony = users(:anthony)
      @bob = users(:bob)
      sign_in @bob
    end
  end
end
