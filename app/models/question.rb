# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable
  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  has_many_attached :files
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true
end
