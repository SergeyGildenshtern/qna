class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }
  expose :question,
         build: ->(question_params) { Question.new(question_params.merge(author: current_resource_owner)) },
         find: -> { Question.with_attached_files.find(params[:id]) }

  load_and_authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    if question.save
      render json: question
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url])
  end
end
