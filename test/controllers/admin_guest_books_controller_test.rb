require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == GuestBooksController test
  #
  class GuestBooksControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @anthony
      get :index, id: @guest_book.id
      assert_redirected_to new_user_session_path
      get :show, id: @guest_book.id
      assert_redirected_to new_user_session_path
      delete :destroy, id: @guest_book.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @guest_book.id
      assert_response :success
    end

    test 'should destroy guest_book' do
      assert_difference ['GuestBook.count'], -1 do
        delete :destroy, id: @guest_book.id
      end
      assert_redirected_to admin_guest_books_path
    end

    test 'should not access new guest_book page if administrator' do
      sign_in @bob
      get :new
      assert_redirected_to admin_dashboard_path
    end

    test 'should not access edit guest_book page if administrator' do
      sign_in @bob
      get :edit, id: @guest_book.id
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Toggling validated column
    #
    test 'should toggle value for validated field if false' do
      assert_not @guest_book_not_validate.validated
      get :toggle_guest_book_validated, id: @guest_book_not_validate.id
      assert assigns(:guest_book).validated
    end

    test 'should toggle value for validated field if true' do
      assert @guest_book.validated
      get :toggle_guest_book_validated, id: @guest_book.id
      assert_not assigns(:guest_book).validated
    end

    test 'should count one more validated message' do
      count_before = GuestBook.validated.count
      get :toggle_guest_book_validated, id: @guest_book_not_validate.id
      assert_equal GuestBook.validated.count, count_before + 1
    end

    test 'should count one less validated message' do
      count_before = GuestBook.validated.count
      get :toggle_guest_book_validated, id: @guest_book.id
      assert_equal GuestBook.validated.count, count_before - 1
    end

    private

    def initialize_test
      @request.env['HTTP_REFERER'] = admin_guest_books_path
      @guest_book = guest_books(:fr_validate)
      @guest_book_not_validate = guest_books(:fr_not_validate)
      @anthony = users(:anthony)
      @bob = users(:bob)
      sign_in @anthony
    end
  end
end
