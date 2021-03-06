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
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # Routes / Templates / Responses
    # ===================================
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get new page if logged in' do
      get :new
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, params: { id: @blog }
      assert_response :success
    end

    test 'should create blog if logged in' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id

      assert_difference 'Blog.count' do
        post :create, params: { blog: attrs }
        blog = assigns(:blog)
        assert blog.valid?
        assert flash[:notice].blank?
        assert_equal @administrator.id, blog.user_id
      end
    end

    test 'should update blog if logged in' do
      patch :update, params: { id: @blog, blog: { title: 'blog edit', content: 'content edit' } }
      assert_redirected_to admin_blog_path(assigns(:blog))
      assert flash[:notice].blank?
    end

    test 'should update nested audio and enqueued it' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      assert_enqueued_jobs 1 do
        patch :update, params: { id: @blog, blog: { audio_attributes: { audio: audio } } }
      end
    end

    #
    # Destroy
    # ==========
    test 'should destroy blog' do
      assert_difference ['Blog.count', 'Audio.count'], -1 do
        delete :destroy, params: { id: @blog }
        assert_redirected_to admin_blogs_path
      end
    end

    test 'AJAX :: should destroy blog' do
      assert_difference ['Blog.count', 'Audio.count'], -1 do
        delete :destroy, params: { id: @blog }, xhr: true
        assert_response :success
        assert_template :destroy
      end
    end

    #
    # Slug
    # =======
    # FIXME: Fix this when FriendlyIdGlobalize will be fixed
    test 'should update slug if title changed' do
      skip 'Fix this when FriendlyIdGlobalize will be fixed'
      attrs = {
        translations_attributes: {
          '1': { title: 'Lorem', locale: 'fr' },
          '0': { title: 'Ipsum', locale: 'en' }
        }
      }
      patch :update, params: { id: @blog, blog: attrs }

      I18n.with_locale(:fr) do
        assert_equal 'lorem', assigns(:blog).slug
      end

      I18n.with_locale(:en) do
        assert_equal 'ipsum', assigns(:blog).slug
      end
    end

    #
    # PublicationDate
    # ====================
    test 'should create nested publication_date if blank attributes' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id

      post :create, params: { blog: attrs }
      blog = assigns(:blog)
      assert blog.publication_date.present?
      assert blog.published_at.nil?
      assert blog.expired_at.nil?

      get :index
      assert_response :success
    end

    test 'should create nested publication_date if attributes filled' do
      published_at = '2029-12-30 12:00:00'.to_datetime
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:publication_date_attributes] = default_publication_date('1', '0', published_at)

      post :create, params: { blog: attrs }
      blog = assigns(:blog)
      assert blog.publication_date.present?
      assert_equal published_at, blog.published_at
      assert blog.expired_at.nil?
    end

    test 'should update blog even when publication_at is current' do
      Timecop.freeze(Time.zone.local(2028, 07, 16, 14, 50, 0)) do
        patch :update, params: { id: @blog, blog: { online: false } }
        blog = assigns(:blog)
        assert blog.valid?
        assert_redirected_to admin_blog_path(blog)
      end
    end

    #
    # Nested resources
    # =====================
    test 'should be able to update naked blog without any errors' do
      patch :update, params: { id: @blog_naked, blog: {} }

      assert assigns(:blog).valid?
      assert_empty assigns(:blog).errors.keys
      assert assigns(:blog).video_upload.blank?
      assert assigns(:blog).audio.blank?
      assert assigns(:blog).video_platform.blank?
      assert_nil flash[:notice]
    end

    #
    # VideoUpload
    # =================
    test 'should be able to update video_upload attributes from naked blog' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, params: { id: @blog_naked, blog: { video_upload_attributes: { video_file: video, online: false } } }
      assert_not assigns(:blog).video_upload.blank?
      assert_not assigns(:blog).video_upload.online?
    end

    test 'should not be able to create blank video_upload attributes from blog' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:video_upload_attributes] = { video_file: '' }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert assigns(:blog).video_upload.blank?
    end

    test 'should be able to create video_upload attributes when creating blog' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:video_upload_attributes] = { video_file: video }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert_not assigns(:blog).video_upload.blank?
    end

    #
    # VideoPlatform
    # =================
    test 'should be able to update naked video_platform attributes from blog' do
      patch :update, params: { id: @blog_naked, blog: { video_platform_attributes: { url: 'http://www.dailymotion.com/video/x2z92v3', online: false } } }
      assert_not assigns(:blog).video_platform.blank?
      assert_not assigns(:blog).video_platform.online?
    end

    test 'should not be able to create blank video_platform attributes from blog' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:video_platform_attributes] = { url: '' }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert assigns(:blog).video_platform.blank?
    end

    test 'should be able to create video_platform attributes when creating blog' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:video_platform_attributes] = { url: 'http://www.dailymotion.com/video/x2z92v3' }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert_not assigns(:blog).video_platform.blank?
    end

    #
    # Audio
    # ==========
    test 'should be able to update audio attributes from blog' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      patch :update, params: { id: @blog_naked, blog: { audio_attributes: { audio: audio, online: false } } }
      assert_not assigns(:blog).audio.blank?
      assert_not assigns(:blog).audio.online?
    end

    test 'should not be able to create blank audio attributes from blog' do
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:audio_attributes] = { audio: '' }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert assigns(:blog).audio.blank?
    end

    test 'should be able to create audio attributes when creating blog' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      attrs = set_default_record_attrs
      attrs[:blog_category_id] = @blog_category.id
      attrs[:audio_attributes] = { audio: audio }

      post :create, params: { blog: attrs }
      assert assigns(:blog).valid?
      assert_not assigns(:blog).audio.blank?
    end

    #
    # Batch actions
    # =================
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@blog.id] }
      [@blog].each(&:reload)
      assert_not @blog.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@blog.id] }
      assert_redirected_to admin_blogs_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, params: { batch_action: 'reset_cache', collection_selection: [@blog.id] }
      assert_redirected_to admin_blogs_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # Flash content
    # ==================
    test 'should return empty flash notice if no update' do
      patch :update, params: { id: @blog, blog: {} }
      assert flash[:notice].blank?
    end

    test 'should return correct flash content after updating a video' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, params: { id: @blog, blog: { video_upload_attributes: { video_file: video } } }
      assert assigns(:blog).video_upload.video_file_processing?, 'should be processing video task'
      assert_equal [I18n.t('video_upload.flash.upload_in_progress')], flash[:notice]
    end

    test 'should return correct flash content after updating an audio file' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      patch :update, params: { id: @blog, blog: { audio_attributes: { audio: audio } } }
      assert assigns(:blog).audio.audio_processing?, 'should be processing audio task'
      assert_equal [I18n.t('audio.flash.upload_in_progress')], flash[:notice]
    end

    test 'should return correct both flash content after updating audio and video files' do
      audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, params: { id: @blog, blog: { audio_attributes: { audio: audio }, video_upload_attributes: { video_file: video } } }
      assert assigns(:blog).audio.audio_processing?, 'should be processing audio task'
      assert assigns(:blog).video_upload.video_file_processing?, 'should be processing video task'
      assert_equal [I18n.t('audio.flash.upload_in_progress'), I18n.t('video_upload.flash.upload_in_progress')], flash[:notice]
    end

    #
    # Validations
    # ===============
    test 'should not save allow_comments params if module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @administrator
      patch :update, params: { id: @blog, blog: { allow_comments: false } }
      assert assigns(:blog).allow_comments?
    end

    test 'should save allow_comments params if module is enabled' do
      patch :update, params: { id: @blog, blog: { allow_comments: false } }
      assert_not assigns(:blog).allow_comments?
    end

    #
    # Maintenance
    # ===============
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
    # Abilities
    # =============
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
    # Subscriber
    # ==============
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@blog, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@blog, admin_dashboard_path, model_name)
    end

    #
    # Module disabled
    # ====================
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
      patch :update, params: { id: @blog_not_validate.id, blog: { audio_attributes: { audio: audio } } }
      assert assigns(:blog).audio.blank?
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_blogs_path

      @blog = blogs(:blog_online)
      @blog_not_validate = blogs(:blog_offline)
      @blog_naked = blogs(:naked)
      @blog_category = blog_categories(:one)

      @blog_module = optional_modules(:blog)
      @comment_module = optional_modules(:comment)
      @audio_module = optional_modules(:audio)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
