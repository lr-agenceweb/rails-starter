# frozen_string_literal: true
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
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get new page if logged in' do
      get :new
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @blog
      assert_response :success
    end

    test 'should create blog if logged in' do
      post :create, blog: { title: 'blog edit', content: 'content edit', blog_category_id: @blog_category.id }
      assert assigns(:blog).valid?
      assert flash[:notice].blank?
      assert_equal @administrator.id, assigns(:blog).user_id
    end

    test 'should update blog if logged in' do
      patch :update, id: @blog, blog: { title: 'blog edit', content: 'content edit' }
      assert_redirected_to admin_blog_path(assigns(:blog))
      assert flash[:notice].blank?
    end

    test 'should destroy blog' do
      assert_difference ['Blog.count'], -1 do
        delete :destroy, id: @blog
      end
      assert_redirected_to admin_blogs_path
    end

    test 'should destroy nested audio with blog' do
      assert_difference ['Audio.count'], -1 do
        delete :destroy, id: @blog
      end
    end

    test 'should update nested audio and enqueued it' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      assert_enqueued_jobs 1 do
        patch :update, id: @blog, blog: { audio_attributes: { audio: audio } }
      end
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@blog.id]
      [@blog].each(&:reload)
      assert_not @blog.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@blog.id]
      assert_redirected_to admin_blogs_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, batch_action: 'reset_cache', collection_selection: [@blog.id]
      assert_redirected_to admin_blogs_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # == Flash content
    #
    test 'should return empty flash notice if no update' do
      patch :update, id: @blog, blog: {}
      assert flash[:notice].blank?
    end

    test 'should return correct flash content after updating a video' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, id: @blog, blog: { video_uploads_attributes: [{ video_file: video }] }
      assert_equal [I18n.t('video_upload.flash.upload_in_progress')], flash[:notice]
    end

    test 'should return correct flash content after updating an audio file' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      patch :update, id: @blog, blog: { audio_attributes: { audio: audio } }
      assert_equal [I18n.t('audio.flash.upload_in_progress')], flash[:notice]
    end

    test 'should return correct both flash content after updating audio and video files' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, id: @blog, blog: { audio_attributes: { audio: audio }, video_uploads_attributes: [{ video_file: video }] }
      assert_equal [I18n.t('audio.flash.upload_in_progress'), I18n.t('video_upload.flash.upload_in_progress')], flash[:notice]
    end

    #
    # == Validations
    #
    test 'should not save allow_comments params if module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @blog, blog: { allow_comments: false }
      assert assigns(:blog).allow_comments?
    end

    test 'should save allow_comments params if module is enabled' do
      patch :update, id: @blog, blog: { allow_comments: false }
      assert_not assigns(:blog).allow_comments?
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
      assert_redirected_to admin_dashboard_path
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
      assert ability.cannot?(:create, Blog.new), 'should not be able to create'
      assert ability.cannot?(:read, @blog), 'should not be able to read'
      assert ability.cannot?(:update, @blog), 'should not be able to update'
      assert ability.cannot?(:destroy, @blog), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @blog), 'should not be able to toggle_online'
      assert ability.cannot?(:reset_cache, @blog), 'should not be able to reset_cache'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @blog), 'should be able to read'
      assert ability.can?(:update, @blog), 'should be able to update'
      assert ability.can?(:destroy, @blog), 'should be able to destroy'

      assert ability.can?(:toggle_online, @blog), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @blog), 'should be able to reset_cache'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @blog), 'should be able to read'
      assert ability.can?(:update, @blog), 'should be able to update'
      assert ability.can?(:destroy, @blog), 'should be able to destroy'

      assert ability.can?(:toggle_online, @blog), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @blog), 'should be able to reset_cache'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@blog, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@blog, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if blog module is disabled' do
      disable_optional_module @super_administrator, @blog_module, 'Blog' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@blog, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@blog, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@blog, admin_dashboard_path, model_name)
    end

    test 'should not save audio nested resource if audio module is disabled' do
      disable_optional_module @super_administrator, @audio_module, 'Audio' # in test_helper.rb
      sign_in @administrator
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      assert @blog_not_validate.audio.blank?
      patch :update, id: @blog_not_validate, blog: { audio_attributes: { audio: audio } }
      assert assigns(:blog).audio.blank?
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_blogs_path

      @blog = blogs(:blog_online)
      @blog_not_validate = blogs(:blog_offline)
      @blog_module = optional_modules(:blog)
      @blog_category = blog_categories(:one)
      @comment_module = optional_modules(:comment)
      @audio_module = optional_modules(:audio)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
