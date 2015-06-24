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
  end

  def administrator_privilege(user)
    can :read, :all
    can :manage, Post
    can :manage, Newsletter
    can [:update, :destroy], NewsletterUser
    can :update, Setting
    can :manage, User, role_name: %w( administrator subscriber )
    can :manage, User, id: user.id
    can :update, Category
    can [:create, :read, :destroy], Comment, user: { role_name: %w( administrator subscriber ) }
    can [:read, :destroy], GuestBook
  end

  def subscriber_privilege(user)
    can [:update, :read, :destroy], User, id: user.id
    can :create, About
    can [:update, :read, :destroy], About, user_id: user.id
    can :manage, Comment, user_id: user.id
    cannot :destroy, Comment, user_id: nil
    cannot :manage, Setting
    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end

  def visitor_privilege
    can :read, Post
    cannot :destroy, :all
    cannot :update, :all
    cannot :create, :all
  end
end
