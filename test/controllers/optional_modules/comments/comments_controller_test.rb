require 'test_helper'

#
# == CommentsController Test
#
class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Create
  #
  test 'should not be able to create comment if no content' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: nil }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
        assert_not assigns(:comment).save
      end
    end
  end

  test 'should not be able to create comment if captcha is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        end
      end
    end
  end

  test 'should not be able to create comment if lang is not set' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should not be able to create comment if lang is not allowed' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'ch' }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should not be able to create comment if email is not valid' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', nickname: '', username: 'leila', email: 'not_valid', lang: locale.to_s }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should create comment with all good and not connected' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        end
        assert assigns(:comment).valid?
        assert_redirected_to @about
      end
    end
  end

  test 'should have informations of user given if not connected' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_nil assigns(:comment).user_id
        assert_equal assigns(:comment).username, 'leila'
        assert_equal assigns(:comment).email, 'leila@skywalker.sw'
        assert_equal assigns(:comment).lang, locale.to_s
      end
    end
  end

  test 'should create comment only with comment field if connected' do
    sign_in @subscriber
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_difference 'Comment.count' do
          post :create, about_id: @about, comment: { comment: 'youpi', lang: locale.to_s }, locale: locale.to_s
        end
        assert assigns(:comment).valid?
        assert_redirected_to @about
      end
    end
  end

  test 'should have informations of sign_in user if connected' do
    sign_in @subscriber
    @locales.each do |locale|
      I18n.with_locale(locale) do
        post :create, about_id: @about, comment: { comment: 'youpi', lang: locale.to_s }, locale: locale.to_s
        assert assigns(:comment).valid?
        assert_nil assigns(:comment).username
        assert_nil assigns(:comment).email
        assert_equal assigns(:comment).user_id, @subscriber.id
      end
    end
  end

  #
  # == Ajax
  #
  test 'AJAX :: should create comment' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :post, :create, format: :js, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'AJAX :: should render show template if comment created' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :post, :create, format: :js, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_template :create
      end
    end
  end

  test 'AJAX :: should not create comment if nickname is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          xhr :post, :create, format: :js, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', nickname: 'robot', lang: locale.to_s }, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Destroy
  #
  test 'should not be able to delete comments if user is not logged in' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          delete :destroy, id: @comment_alice, about_id: @about, locale: locale.to_s
          assert_equal I18n.t('comment.destroy.not_allowed'), flash[:error]
          assert flash[:success].blank?
        end
      end
    end
  end

  test 'should be able to delete every comments if user is SA' do
    if @locales.include?(:fr)
      sign_in @super_administrator
      locale = 'fr'
      I18n.with_locale(locale) do
        assert_difference 'Comment.count', -1 do
          delete :destroy, id: @comment_alice, about_id: @about, locale: locale
          assert_equal I18n.t('comment.destroy.success'), flash[:success]
          assert flash[:error].blank?
        end
      end
    end
  end

  test 'subscriber should not be able to delete comments except his own' do
    sign_in @subscriber
    locale = 'fr'
    I18n.with_locale(locale) do
      assert_difference 'Comment.count', -1 do
        delete :destroy, id: @comment_lana, about_id: @about, locale: locale
        assert_equal I18n.t('comment.destroy.success'), flash[:success]
      end

      assert_no_difference 'Comment.count' do
        delete :destroy, id: @comment_alice, about_id: @about, locale: locale
        assert_equal I18n.t('comment.destroy.not_allowed'), flash[:error]
      end
    end
  end

  test 'administrator should be able to delete comments except SA' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    locale = 'fr'

    I18n.with_locale(locale) do
      assert ability.can?(:destroy, @comment_lana)
      assert_difference 'Comment.count', -1 do
        delete :destroy, id: @comment_lana, about_id: @about, locale: locale
        assert_equal I18n.t('comment.destroy.success'), flash[:success]
      end

      assert ability.cannot?(:destroy, @comment_anthony)
      assert_no_difference 'Comment.count' do
        delete :destroy, id: @comment_anthony, about_id: @about, locale: locale
        assert_equal I18n.t('comment.destroy.not_allowed'), flash[:error]
      end
    end
  end

  test 'should destroy comment with children if any' do
    sign_in @administrator
    @comment_anthony.update_attribute(:parent_id, @comment_lana.id)
    @comment_bob.update_attribute(:parent_id, @comment_lana.id)
    @comment_alice.update_attribute(:parent_id, @comment_lana.id)

    assert_difference 'Comment.count', -4 do
      delete :destroy, id: @comment_lana, about_id: @about, locale: 'fr'
    end
  end

  test 'should redirect to show page if destroy root' do
    sign_in @administrator
    @comment_anthony.update_attribute(:parent_id, @comment_lana.id)
    @comment_bob.update_attribute(:parent_id, @comment_lana.id)
    @comment_alice.update_attribute(:parent_id, @comment_lana.id)

    delete :destroy, id: @comment_lana, about_id: @about, locale: 'fr'
    assert_redirected_to @about
  end

  test 'AJAX :: should destroy comment with children if any' do
    sign_in @administrator
    @comment_anthony.update_attribute(:parent_id, @comment_lana.id)
    @comment_bob.update_attribute(:parent_id, @comment_lana.id)
    @comment_alice.update_attribute(:parent_id, @comment_lana.id)

    assert_difference 'Comment.count', -4 do
      xhr :delete, :destroy, format: :js, id: @comment_lana, about_id: @about, locale: 'fr'
    end
  end

  #
  # == Flash
  #
  test 'should have correct flash if should validate' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_equal I18n.t('comment.create_success_with_validate'), flash[:success]
      end
    end
  end

  test 'should have correct flash if should not validate' do
    @comment_setting.update_attribute(:should_validate, false)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_equal I18n.t('comment.create_success'), flash[:success]
      end
    end
  end

  test 'AJAX :: should have correct flash if should validate' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_equal I18n.t('comment.create_success_with_validate'), flash[:success]
      end
    end
  end

  test 'AJAX :: should have correct flash if should not validate' do
    @comment_setting.update_attribute(:should_validate, false)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, about_id: @about, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_equal I18n.t('comment.create_success'), flash[:success]
      end
    end
  end

  #
  # == Signal
  #
  test 'should signal comment' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        @request.env['HTTP_REFERER'] = about_path(@about, locale: locale.to_s)
        get :signal, token: @comment_alice.token, about_id: @about, id: @comment_alice, locale: locale.to_s
        assert assigns(:comment).signalled?
        assert_redirected_to about_path(@about, locale: locale.to_s)
      end
    end
  end

  test 'should not signal non existant comment' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_raises(ActionController::RoutingError) do
          get :signal, id: 999_999, token: @comment_alice.token, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'should render 404 if token not set for signal' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_raises(ActionController::RoutingError) do
          get :signal, id: @comment_alice, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'should send email to admin after signalling email' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?
        @request.env['HTTP_REFERER'] = about_path(@about)

        assert_enqueued_jobs 1 do
          get :signal, id: @comment_alice, token: @comment_alice.token, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'should not send email to admin if send_email is disabled' do
    @comment_setting.update_attribute(:send_email, false)
    assert @comment_setting.should_signal?
    assert_not @comment_setting.send_email?
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?
        @request.env['HTTP_REFERER'] = about_path(@about)
        assert_enqueued_jobs 0 do
          get :signal, id: @comment_alice, token: @comment_alice.token, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'should not send email to admin if should_signal disabled but send_email is enabled' do
    @comment_setting.update_attribute(:should_signal, false)
    assert_not @comment_setting.should_signal?
    assert @comment_setting.send_email?
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?
        @request.env['HTTP_REFERER'] = about_path(@about)

        assert_raises(ActionController::RoutingError) do
          assert_enqueued_jobs 0 do
            get :signal, id: @comment_alice, token: @comment_alice.token, about_id: @about, locale: locale.to_s
          end
        end
      end
    end
  end

  test 'AJAX :: should signal comment' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :signal, format: :js, id: @comment_luke.id, token: @comment_luke.token, about_id: @about, locale: locale.to_s
        assert_response :success
        assert assigns(:comment).signalled?
      end
    end
  end

  test 'AJAX :: should render 404 if token not set for signal' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_raises(ActionController::RoutingError) do
          xhr :get, :signal, format: :js, id: @comment_luke.id, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'AJAX :: should send email to admin after signalling email' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?

        assert_enqueued_jobs 1 do
          xhr :get, :signal, format: :js, id: @comment_luke.id, token: @comment_luke.token, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'AJAX :: should not send email to admin if send_email is disabled' do
    @comment_setting.update_attribute(:send_email, false)
    assert @comment_setting.should_signal?
    assert_not @comment_setting.send_email?
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?

        assert_enqueued_jobs 0 do
          xhr :get, :signal, format: :js, id: @comment_luke.id, token: @comment_luke.token, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'AJAX :: should not send email to admin if should_signal disabled but send_email is enabled' do
    @comment_setting.update_attribute(:should_signal, false)
    assert_not @comment_setting.should_signal?
    assert @comment_setting.send_email?
    @locales.each do |locale|
      I18n.with_locale(locale) do
        clear_deliveries_and_queues
        assert_no_enqueued_jobs
        assert ActionMailer::Base.deliveries.empty?

        assert_raises(ActionController::RoutingError) do
          assert_enqueued_jobs 0 do
            xhr :get, :signal, format: :js, id: @comment_luke.id, token: @comment_luke.token, about_id: @about, locale: locale.to_s
          end
        end
      end
    end
  end

  #
  # == Reply
  #
  test 'should render reply template and success response' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :reply, token: @comment_alice.token, about_id: @about, id: @comment_alice, locale: locale.to_s
        assert_response :success
        assert_template :reply
      end
    end
  end

  test 'should render 404 if token not set for reply' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_raises(ActionController::RoutingError) do
          get :reply, token: '', id: @comment_alice, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  test 'AJAX :: should render reply template and success response' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :reply, format: :js, id: @comment_alice.id, token: @comment_alice.token, about_id: @about, locale: locale.to_s
        assert_response :success
        assert_template :reply
      end
    end
  end

  test 'should save children of a comment' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        post :create, about_id: @about, id: @comment_alice, comment: { parent_id: @comment_alice.id }, locale: locale.to_s
        assert_equal @comment_alice.id, assigns(:comment).parent_id
      end
    end
  end

  test 'AJAX :: should render 404 if token not set for reply' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        assert_raises(ActionController::RoutingError) do
          xhr :get, :reply, token: '', id: @comment_luke.id, about_id: @about, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Conditionals
  #
  test 'should fetch only validated comments' do
    @comments = Comment.validated
    assert_equal @comments.length, 2
  end

  #
  # == Locales
  #
  test 'should fetch only comments from current locale' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        @comments = Comment.by_locale(locale.to_s)
        assert_equal @comments.length, 3 if locale == 'fr'
        assert_equal @comments.length, 2 if locale == 'en'
      end
    end
  end

  test 'should fetch only comments from current locale and validated' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        @comments = Comment.validated.by_locale(locale.to_s)
        assert_equal @comments.length, 1 if locale == 'fr'
        assert_equal @comments.length, 1 if locale == 'en'
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @about = posts(:about_2)
    @comment_setting = comment_settings(:one)

    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:lana)

    @comment_anthony = comments(:one)
    @comment_bob = comments(:two)
    @comment_alice = comments(:three)
    @comment_lana = comments(:four)
    @comment_luke = comments(:five)
  end
end
