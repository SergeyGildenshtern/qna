class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :best, :created_at, :updated_at
end
