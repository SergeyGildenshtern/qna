class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :author_id, :best, :created_at, :updated_at

  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
end
