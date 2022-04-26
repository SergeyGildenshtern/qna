class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :author_id, :created_at, :updated_at

  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
end
