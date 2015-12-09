#
# == Ability Class
#
class Ability
  include CanCan::Ability

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
    can :manage, User, id: @user.id
    optional_modules_check
    can :manage, StringBox, optional_module_id: nil
  end

  def administrator_privilege
    can :read, :all
    can :manage, [Post, MailingUser]
    can :update, [Setting, Category]
    can [:read, :update], Menu
    can [:read, :destroy, :update], User, role_name: %w( subscriber )
    cannot :create, User
    cannot [:update, :destroy], User, role: { name: %w( administrator ) }
    cannot :manage, User, role: { name: %w( super_administrator ) }
    can :manage, User, id: @user.id
    can [:read, :update, :destroy], Picture
    cannot :manage, OptionalModule
    cannot [:read, :update, :destroy], [About, LegalNotice]
    can :manage, [About, LegalNotice], user_id: @user.id
    optional_modules_check
    can [:read, :update], StringBox, optional_module_id: nil
  end

  def subscriber_privilege
    cannot_manage_optional_modules
    can [:update, :read, :destroy], User, id: @user.id
    cannot :create, User
    can [:create, :read, :destroy], Comment, user_id: @user.id
    cannot :destroy, Comment, user_id: nil
    cannot :manage, [Home, About, Setting, Picture, StringBox, Menu, LegalNotice]
    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end

  def visitor_privilege
    can :read, Post
    cannot [:create, :update, :destroy], :all
    cannot_manage_optional_modules
  end

  def cannot_manage_optional_modules
    cannot :manage, [OptionalModule, GuestBook, NewsletterUser, NewsletterSetting, Comment, Blog, Slider, Event, EventSetting, Map, Newsletter, Social, Background, VideoUpload, VideoPlatform, VideoSubtitle, VideoSetting, AdultSetting, MailingUser]
  end

  def optional_modules_check
    guest_book_module
    newsletter_module
    comment_module
    blog_module
    slider_module
    event_module
    map_module
    social_module
    background_module
    adult_module
    video_module
  end

  #
  # == GuestBook
  #
  def guest_book_module
    if @guest_book_module.enabled?
      can [:read, :destroy], GuestBook
      cannot [:create, :update], GuestBook
    else
      cannot :manage, GuestBook
    end
  end

  #
  # == Newsletter
  #
  def newsletter_module
    if @newsletter_module.enabled?
      can :manage, Newsletter
      can :crud, NewsletterUser
      can [:read, :update], NewsletterSetting
      cannot [:create, :destroy], NewsletterSetting
    else
      cannot :manage, [Newsletter, NewsletterUser, NewsletterSetting]
      cannot :manage, StringBox, optional_module_id: @newsletter_module.id unless @newsletter_module.enabled?
    end
  end

  #
  # == Comment
  #
  def comment_module
    if @comment_module.enabled?
      can [:read, :destroy], Comment, user: { role_name: %w( administrator subscriber ) }
      can [:read, :destroy], Comment, user_id: nil
      cannot [:create, :update], Comment
      can :destroy, Comment if @user.super_administrator?
    else
      cannot :manage, Comment
    end
  end

  #
  # == Blog
  #
  def blog_module
    if @blog_module.enabled?
      can :crud, Blog
      can [:read, :update], BlogSetting
      cannot [:create, :destroy], BlogSetting
    else
      cannot :manage, [Blog, BlogSetting]
    end
  end

  #
  # == Slider
  #
  def slider_module
    if @slider_module.enabled?
      can :crud, [Slider, Slide]
      cannot :create, Slide
    else
      cannot :manage, [Slider, Slide]
    end
  end

  #
  # == Event
  #
  def event_module
    if @event_module.enabled?
      can :crud, Event
      can [:read, :update], EventSetting
      cannot [:create, :destroy], EventSetting
    else
      cannot :manage, [Event, EventSetting]
    end
  end

  #
  # == Map
  #
  def map_module
    if @map_module.enabled?
      can [:update, :read], Map
      cannot [:create, :destroy], Map
    else
      cannot :manage, Map
    end
  end

  #
  # == Social
  #
  def social_module
    if @social_module.enabled?
      can [:update, :read], Social
      cannot [:create, :destroy], Social if @user.administrator?
    else
      cannot :manage, Social
    end
  end

  #
  # == Background
  #
  def background_module
    if @background_module.enabled?
      can :crud, Background
    else
      cannot :manage, Background
    end
  end

  #
  # == Adult
  #
  def adult_module
    if @adult_module.enabled?
      can [:read, :update], AdultSetting
      cannot [:create, :destroy], AdultSetting
    else
      cannot :manage, AdultSetting
      cannot :manage, StringBox, optional_module: { id: @adult_module.id }
    end
  end

  #
  # == Video
  #
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
end
