class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :author_id, :created_at, :updated_at
end
