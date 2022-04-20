class LinksController < ApplicationController
  expose :link

  load_and_authorize_resource

  def destroy
    link.destroy
  end
end
