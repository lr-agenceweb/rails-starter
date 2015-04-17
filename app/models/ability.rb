#
# == Ability Class
#
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.super_administrator?
      can :manage, :all

    elsif user.administrator?
      can :read, :all
      can :manage, Post
      can :update, Setting
      can :manage, User, role_name: %w( administrator subscriber )
      can :manage, User, id: user.id
      can :update, Category
      can [:create, :read, :destroy], Comment, user: { role_name: %w( administrator subscriber ) }

    elsif user.subscriber?
      can [:update, :read, :destroy], User, id: user.id
      can :manage, Post, id: user.id
      can :manage, Comment, user_id: user.id
    end
  end
end
