class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  expose :question
  expose :answer,
         build: ->(answer_params) { question.answers.new(answer_params.merge(author: current_user)) },
         find: -> { Answer.with_attached_files.find(params[:id]) }

  load_and_authorize_resource

  def create
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def update_best
    answer.update_best!
    answer.question.reward&.update(user: answer.author)
  end

  private

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{answer.question_id}/answers",
      {
        answer: answer.body,
        answer_id: answer.id,
        answer_author_id: answer.author_id
      }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
