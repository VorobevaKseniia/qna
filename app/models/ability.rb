# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if (user)
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Link, Award, ActiveStorage::Attachment, Subscription]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Subscription], user: user
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }

    can :mark_as_best, Answer do |answer|
      user.author?(answer.question)
    end

    can :vote, [Question, Answer] do |object|
      !user.author?(object)
    end
  end
end
