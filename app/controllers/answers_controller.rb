class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answer

  def create
    answer.question = question
    answer.author = current_user
    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question, notice: 'Your answer successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
