class AnswersController < ApplicationController
  expose :question
  expose :answer, build: ->(params) { question.answers.new(params) }

  def create
    if answer.save
      redirect_to question
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
