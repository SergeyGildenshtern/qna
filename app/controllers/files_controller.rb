class FilesController < ApplicationController
  expose :file, find: ->(id) { ActiveStorage::Attachment.find(id) }

  def destroy
    authorize! :destroy, file
    file.purge
  end
end
