class LinksController < ApplicationController
  expose :link

  def destroy
    link.destroy if current_user.author?(link.linkable)
  end
end
