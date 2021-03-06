# frozen_string_literal: true

#
# Ability Class
# ===============
class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    user ||= User.new # visitor user (not logged in)
    @user = user
    set_optional_modules

    alias_action :create, :read, :update, :destroy, to: :crud

    if @user.super_administrator?
      super_administrator_privilege
    elsif @user.administrator?
      administrator_privilege
    elsif @user.subscriber?
      subscriber_privilege
    else
      visitor_privilege
    end
  end

  private

  def set_optional_modules
    optional_modules = OptionalModule.all
    optional_modules.find_each do |optional_module|
      instance_variable_set("@#{optional_module.name.underscore.singularize}_module", optional_module)
    end
  end

  def super_administrator_privilege
    can :manage, :all
    cannot [:update, :destroy], User, role: { name: 'super_administrator' }
    cannot [:unlink], User
    can :manage, User, id: @user.id
    optional_modules_check
    can :manage, StringBox
    super_admin_batch_actions # Batch actions
  end

  def administrator_privilege
    can :read, :all
    can [:crud], [Post]
    can :update, [Setting]

    # Menu / Page
    cannot [:create, :destroy, :read], [Menu, Page], optional_module: { enabled: false }
    can [:update, :read], [Menu, Page], optional_module: { enabled: true }
    can [:update, :read], [Page], optional_module: nil
    can [:update, :read], [Menu], page: { optional_module_id: nil }

    can [:read, :destroy, :update], User, role_name: %w(subscriber)
    cannot [:create, :unlink], User
    cannot [:update, :destroy], User, role: { name: %w(administrator) }
    cannot :manage, User, role: { name: %w(super_administrator) }
    can :manage, User, id: @user.id
    can [:read, :update, :destroy], Picture
    cannot :manage, OptionalModule
    cannot [:read, :update, :destroy], [About, LegalNotice]
    can :manage, [About, LegalNotice], user_id: @user.id
    can [:read, :update], StringBox
    can :manage, Connection

    admin_batch_actions # Batch actions
    optional_modules_check # Optional modules
  end

  def subscriber_privilege
    cannot_manage_optional_modules
    rss_module
    comment_frontend
    newsletter_frontend
    mailing_frontend
    can :mapbox_popup, Contact
    can [:update, :read, :destroy, :unlink], User, id: @user.id
    cannot [:create], User
    can [:create, :read, :destroy], Comment, user_id: @user.id
    cannot :destroy, Comment, user_id: nil
    cannot :manage, [Home, About, Setting, Picture, StringBox, Menu, LegalNotice]
    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end

  def visitor_privilege
    cannot_manage_optional_modules
    cannot [:create, :update, :destroy], :all
    can [:read], Post
    rss_module
    comment_frontend
  end

  def cannot_manage_optional_modules
    cannot :manage, :all
  end

  def optional_modules_check
    comment_frontend
    mailing_frontend
    mailing_module
    newsletter_frontend
    newsletter_module
    comment_module
    guest_book_module
    blog_module
    slider_module
    event_module
    map_module
    social_module
    background_module
    adult_module
    video_module
    social_connect_module
    audio_module
    rss_module
  end

  #
  # GuestBook
  # ===========
  def guest_book_module
    if @guest_book_module.enabled?
      can [:read, :destroy], GuestBook
      cannot [:create, :update], GuestBook
      can [:read, :update], GuestBookSetting
      cannot [:create, :destroy], GuestBookSetting
    else
      cannot :manage, [GuestBook, GuestBookSetting]
    end
  end

  #
  # Newsletter
  # ============
  def newsletter_module
    if @newsletter_module.enabled?
      can [:crud, :send, :preview], Newsletter
      can :crud, NewsletterUser
      can [:read, :update], [NewsletterSetting, MailingSetting]
      cannot [:create, :destroy], [NewsletterSetting, MailingSetting]
    else
      cannot :manage, [Newsletter, NewsletterUser, NewsletterSetting]
    end
  end

  def newsletter_frontend
    return unless @newsletter_module.enabled?
    can [:preview_in_browser, :welcome_user], Newsletter
    can [:unsubscribe], NewsletterUser
  end

  #
  # Mailing
  # =========
  def mailing_module
    if @mailing_module.enabled?
      can [:crud,
           :send_mailing_message,
           :preview], MailingMessage
      can [:crud], MailingUser
      can [:read, :update], [MailingSetting]
      cannot [:create, :destroy], [MailingSetting]
    else
      cannot :manage, [MailingUser, MailingSetting, MailingMessage]
    end
  end

  def mailing_frontend
    return unless @mailing_module.enabled?
    can :preview_in_browser, MailingMessage
    can :unsubscribe, MailingUser
  end

  #
  # Comment
  # =========
  def comment_module
    if @comment_module.enabled?
      can [:read, :destroy], Comment, user: { role_name: %w(administrator subscriber) }
      can [:read, :destroy], Comment, user_id: nil
      cannot [:create, :update], Comment
      can :destroy, Comment if @user.super_administrator?
      can [:read, :update], CommentSetting
      cannot [:create, :destroy], CommentSetting
    else
      cannot :manage, [Comment, CommentSetting]
    end
  end

  def comment_frontend
    @comment_setting = CommentSetting.first
    if @comment_module.enabled?
      cannot [:signal, :reply], Comment
      can [:signal], Comment if @comment_setting.should_signal?
      can [:reply], Comment if @comment_setting.allow_reply?
      cannot [:reply], Comment, &:max_depth?
    else
      cannot :manage, Comment
    end
  end

  #
  # Slider
  # ========
  def slider_module
    if @slider_module.enabled?
      can :crud, [Slider, Slide]
      cannot :create, Slide
    else
      cannot :manage, [Slider, Slide]
    end
  end

  #
  # Blog / Event
  # ==============
  [Blog, Event].each do |model_object|
    define_method "#{model_object.to_s.underscore}_module" do
      model_object_setting = "#{model_object}Setting".constantize
      model_object_category = model_object == Blog ? "#{model_object}Category".constantize : ''
      if instance_variable_get(:"@#{model_object.to_s.underscore}_module").enabled?
        can :crud, [model_object, model_object_category]
        can [:read, :update], model_object_setting
        cannot [:create, :destroy], model_object_setting
      else
        cannot :manage, [model_object, model_object_setting, model_object_category]
      end
    end
  end

  #
  # Map
  # =====
  def map_module
    if @map_module.enabled?
      can [:update, :read], MapSetting
      cannot [:create, :destroy], MapSetting
      can :mapbox_popup, Contact
    else
      cannot :manage, MapSetting
    end
  end

  #
  # Social
  # ========
  def social_module
    if @social_module.enabled?
      can [:update, :read], Social
      cannot [:create, :destroy], Social if @user.administrator?
    else
      cannot :manage, Social
    end
  end

  #
  # Background
  # ============
  def background_module
    if @background_module.enabled?
      can :crud, Background
    else
      cannot :manage, Background
    end
  end

  #
  # Adult
  # =======
  def adult_module
    if @adult_module.enabled?
      can [:read, :update], AdultSetting
      cannot [:create, :destroy], AdultSetting
    else
      cannot :manage, AdultSetting
    end
  end

  #
  # Video
  # =======
  def video_module
    @video_settings = VideoSetting.first
    if @video_module.enabled?
      can [:read, :update], [VideoSetting]
      cannot [:create, :destroy], [VideoSetting]

      if @video_settings.video_platform?
        can [:read, :update, :destroy], VideoPlatform
        cannot :create, VideoPlatform
      else
        cannot :manage, VideoPlatform
      end

      if @video_settings.video_upload?
        can [:read, :update, :destroy], VideoUpload
        cannot :create, VideoUpload
      else
        cannot :manage, VideoUpload
      end
    else
      cannot :manage, [VideoPlatform, VideoUpload, VideoSubtitle, VideoSetting]
    end
  end

  #
  # SocialConnect
  # ===============
  def social_connect_module
    if @social_connect_module.enabled?
      can [:read, :update], [SocialConnectSetting]
      cannot [:create, :destroy], [SocialConnectSetting]
    else
      cannot :manage, [SocialConnectSetting, SocialProvider]
    end
  end

  #
  # Audio
  # =======
  def audio_module
    if @audio_module.enabled?
      can [:read, :update, :destroy], Audio
      cannot :create, Audio
    else
      cannot :manage, Audio
    end
  end

  #
  # RSS
  # =====
  def rss_module
    if @rss_module.enabled?
      can :feed, Post
    else
      cannot :feed, Post
    end
  end

  #
  # batch_actions
  # ===============
  def super_admin_batch_actions
    can [:toggle_active], User, role: { name: %w(administrator subscriber) }
    cannot [:toggle_active], User, id: @user.id
    cannot [:toggle_active], User, role: { name: %w(super_administrator) }
  end

  def admin_batch_actions
    can [:reset_cache, :toggle_online, :toggle_enabled], :all
    can [:toggle_validated, :toggle_signalled], [Comment, GuestBook]
    can [:toggle_archive_customer], [MailingUser]
    can [:toggle_show_calendar], [Event]
    can [:toggle_active], User, role: { name: %w(subscriber) }
    cannot [:toggle_active], User, id: @user.id
    cannot [:toggle_enabled], OptionalModule
  end
end
