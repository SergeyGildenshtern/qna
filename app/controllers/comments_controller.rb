class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  expose :commentable, find: -> { commentable_name.singularize.capitalize.constantize.find(params[:commentable_id]) }
  expose :comment, build: ->{ current_user.comments.create(comment_params.merge(commentable: commentable)) }

  authorize_resource

  def create
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def commentable_name
    params[:commentable_type]
  end

  def publish_comment
    return if comment.errors.any?
    ActionCable.server.broadcast(
      'comments',
      {
        comment: comment.text,
        commentable_id: comment.commentable_id,
        commentable_type: comment.commentable_type.underscore,
        author_email: comment.author.email
      }
    )
  end
end
