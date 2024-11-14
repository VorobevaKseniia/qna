# frozen_string_literal: true

class User < ApplicationRecord
  include Votable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author?(object)
    object.user_id == id
  end
end
