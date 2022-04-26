class Api::V1::AnswersController < Api::V1::BaseController
  expose :question
  expose :answer,
         build: ->(answer_params) { question.answers.new(answer_params.merge(author: current_user)) },
         find: -> { Answer.with_attached_files.find(params[:id]) }

  load_and_authorize_resource

  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  def create
    if answer.save
      render json: answer
    else
      render json: answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      render json: answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
