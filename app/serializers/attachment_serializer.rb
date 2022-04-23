class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at

  def url
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
