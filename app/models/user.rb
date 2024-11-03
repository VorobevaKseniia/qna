# frozen_string_literal: true

class User < ApplicationRecord
  include Votable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author?(object)
    object.user_id == id
  end
end
