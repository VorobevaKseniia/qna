class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :attached_files, :created_at, :updated_at

  belongs_to :user
  has_many :comments
  has_many :links

  include Attachable
end
