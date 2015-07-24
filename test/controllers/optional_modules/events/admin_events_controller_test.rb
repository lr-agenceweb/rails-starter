require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == EventsController test
  #
  class EventsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index, id: @event
      assert_redirected_to new_user_session_path
      get :show, id: @event
      assert_redirected_to new_user_session_path
      patch :update, id: @event
      assert_redirected_to new_user_session_path
      delete :destroy, id: @event
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @event
      assert_response :success
    end

    test 'should access edit page if logged in' do
      get :edit, id: @event
      assert_response :success
    end

    test 'should update event if logged in' do
      patch :update, id: @event, event: { title: 'event edit', content: 'content edit' }
      assert_redirected_to admin_event_path(assigns(:event))
    end

    #
    # == Destroy
    #
    test 'should destroy event' do
      assert_difference ['Event.count'], -1 do
        delete :destroy, id: @event
      end
      assert_redirected_to admin_events_path
    end

    #
    # == Validation rules
    #
    test 'should save event if link is correct' do
      assert_difference ['Event.count'] do
        post :create, event: { url: 'http://google.com' }
      end
      assert assigns(:event).valid?
    end

    test 'should not save event if link is not correct' do
      assert_no_difference ['Event.count'] do
        post :create, event: { url: 'fake.url' }
      end
      assert_not assigns(:event).valid?
    end

    test 'should save event if dates are corrects' do
      assert_difference ['Event.count'] do
        post :create, event: { start_date: '2015-07-19 09:00:00', end_date: '2015-07-22 09:00:00' }
      end
      assert assigns(:event).valid?
    end

    test 'should save event if dates are equals but hours corrects' do
      assert_difference ['Event.count'] do
        post :create, event: { start_date: '2015-07-19 09:00:00', end_date: '2015-07-19 10:00:00' }
      end
      assert assigns(:event).valid?
    end

    test 'should not save event if dates are not corrects' do
      assert_no_difference ['Event.count'] do
        post :create, event: { start_date: '2015-07-22 09:00:00', end_date: '2015-07-19 09:00:00' }
      end
      assert_not assigns(:event).valid?
    end

    #
    # == Module disabled
    #
    test 'should not access page if event module is disabled' do
      disable_optional_module @super_administrator, @event_module, 'Event' # in test_helper.rb
      sign_in @administrator
      get :index
      assert_redirected_to admin_dashboard_path
    end

    private

    def initialize_test
      @request.env['HTTP_REFERER'] = admin_events_path
      @event = events(:event_online)
      @event_not_validate = events(:event_offline)
      @event_module = optional_modules(:event)

      @super_administrator = users(:anthony)
      @administrator = users(:bob)
      sign_in @administrator
    end
  end
end
