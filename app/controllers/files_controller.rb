class FilesController < ApplicationController
  expose :file, find: ->(id) { ActiveStorage::Attachment.find(id) }

  def destroy
    file.purge if current_user.author?(file.record)
  end
end
