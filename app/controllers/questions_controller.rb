class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  expose :questions, -> { Question.all }
  expose :question,
         build: ->(question_params) { Question.new(question_params.merge(author: current_user)) },
         find: -> { Question.with_attached_files.find(params[:id]) }
  expose :answer, -> { Answer.new }

  def show
    answer.links.build
  end

  def new
    question.links.build
    question.reward = Reward.new(question: question)
  end

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url],
                                     reward_attributes: [:name, :image])
  end
end
