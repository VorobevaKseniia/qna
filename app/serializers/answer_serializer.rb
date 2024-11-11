class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body,:question_id, :user_id, :attached_files, :created_at, :updated_at

  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :links

  attribute :attached_files

  def attached_files
    object.files.map do |file|
      AttachedFileSerializer.new(file).as_json
    end
  end
end