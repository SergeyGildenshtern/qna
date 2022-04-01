class VotesController < ApplicationController
  before_action :authenticate_user!

  expose :votable, find: -> { params[:votable].constantize.find(params[:votable_id]) if params[:votable] }

  before_action :author_verification

  def vote
    unless votable.voted?(current_user)
      new_vote = true
      votable.votes.create(status: params[:status], user: current_user)
    else
      new_vote = false
      votable.vote(current_user).destroy
    end

    respond_to do |format|
      format.json { render json: Hash[:votable, votable, :rating, votable.rating, :new_vote, new_vote] }
    end
  end

  private

  def author_verification
    return head(:forbidden) if votable.author == current_user
  end
end
