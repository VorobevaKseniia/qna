class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp, message: 'incorrect link format' }

  def gist?
    url.start_with?("https://gist.github.com/")
  end
end
