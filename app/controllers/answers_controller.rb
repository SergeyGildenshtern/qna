class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answer,
         build: ->(answer_params) { question.answers.new(answer_params.merge(author: current_user)) },
         find: -> { Answer.with_attached_files.find(params[:id]) }

  def create
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def update_best
    answer.update_best! if current_user.author?(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
