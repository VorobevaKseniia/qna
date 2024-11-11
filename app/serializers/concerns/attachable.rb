module Attachable
  extend ActiveSupport::Concern

  included do
    attribute :attached_files
  end

  def attached_files
    object.files.map do |file|
      AttachedFileSerializer.new(file).as_json
    end
  end
end