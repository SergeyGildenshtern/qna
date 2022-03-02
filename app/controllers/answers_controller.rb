class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answer, build: ->(answer_params) { question.answers.new(answer_params.merge(author: current_user)) }

  def create
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to answer.question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
