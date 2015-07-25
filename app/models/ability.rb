#
# == Ability Class
#
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # visitor user (not logged in)

    if user.super_administrator?
      super_administrator_privilege
    elsif user.administrator?
      administrator_privilege(user)
    elsif user.subscriber?
      subscriber_privilege(user)
    else
      visitor_privilege
    end
  end

  private

  def super_administrator_privilege
    can :manage, :all
    optional_modules_check
    can :destroy, Comment
  end

  def administrator_privilege(user)
    can :read, :all
    can :manage, Post
    can :manage, Newsletter
    can [:update, :destroy], NewsletterUser
    can :update, Setting
    can :manage, User, role_name: %w( administrator subscriber )
    can :manage, User, id: user.id
    cannot :create, User
    can :update, Category
    can [:read, :destroy], GuestBook
    can [:read, :update, :destroy], Background
    cannot :manage, OptionalModule

    optional_modules_check
  end

  def subscriber_privilege(user)
    can [:update, :read, :destroy], User, id: user.id
    cannot :create, User
    can :create, About
    can [:update, :read, :destroy], About, user_id: user.id
    can [:create, :read, :destroy], Comment, user_id: user.id
    cannot :destroy, Comment, user_id: nil
    cannot :manage, Setting
    cannot :manage, OptionalModule
    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end

  def visitor_privilege
    can :read, Post
    cannot :destroy, :all
    cannot :update, :all
    cannot :create, :all
  end

  def optional_modules_check
    optional_modules = OptionalModule.all

    #
    # == GuestBook
    #
    if optional_modules.by_name('GuestBook').enabled?
      can [:read, :destroy], GuestBook
    else
      cannot :manage, GuestBook
    end

    #
    # == Newsletter
    #
    if optional_modules.by_name('Newsletter').enabled?
      can :manage, Newsletter
      can [:read, :update, :destroy], NewsletterUser
    else
      cannot :manage, Newsletter
      cannot :manage, NewsletterUser
    end

    #
    # == Comment
    #
    if optional_modules.by_name('Comment').enabled?
      can [:read, :destroy], Comment, user: { role_name: %w( administrator subscriber ) }
      can [:read, :destroy], Comment, user_id: nil
      cannot :update, Comment
    else
      cannot :manage, Comment
    end

    #
    # == Blog
    #
    if optional_modules.by_name('Blog').enabled?
      can :manage, Blog
    else
      cannot :manage, Blog
    end

    #
    # == Slider
    #
    if optional_modules.by_name('Slider').enabled?
      can :manage, Slider
    else
      cannot :manage, Slider
    end

    #
    # == Event
    #
    if optional_modules.by_name('Event').enabled?
      can :manage, Event
    else
      cannot :manage, Event
    end

    #
    # == Map
    #
    if optional_modules.by_name('Map').enabled?
      can [:update, :read], Map
      cannot [:create, :destroy], Map
    else
      cannot :manage, Map
    end
  end
end
