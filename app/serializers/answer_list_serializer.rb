class AnswerListSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :created_at, :updated_at

  belongs_to :user
  belongs_to :question
end