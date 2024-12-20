module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def likes
    votes.where(value: 1).count
  end

  def dislikes
    votes.where(value: -1).count
  end
end
