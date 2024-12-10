class Comment < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by, against: [:body], using: { tsearch: { prefix: true } }

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true
end
