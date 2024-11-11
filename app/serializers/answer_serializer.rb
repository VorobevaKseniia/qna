class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body,:question_id, :user_id, :attached_files, :created_at, :updated_at

  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :links

  include Attachable
end