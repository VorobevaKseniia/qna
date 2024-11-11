class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :attached_files, :created_at, :updated_at

  belongs_to :user
  has_many :comments
  has_many :links

  attribute :attached_files

  def attached_files
    object.files.map do |file|
      AttachedFileSerializer.new(file).as_json
    end
  end
end
