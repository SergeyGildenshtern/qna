class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  expose :question
  expose :answer,
         build: ->(answer_params) { question.answers.new(answer_params.merge(author: current_user)) },
         find: -> { Answer.with_attached_files.find(params[:id]) }

  def create
    respond_to do |format|
      if answer.save
        format.html { render answer }
        format.json { render json: answer }
      else
        format.html { render partial: 'shared/errors', locals: { resource: answer }, status: :unprocessable_entity }
        format.json { render json: answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def update_best
    if current_user.author?(answer.question)
      answer.update_best!
      answer.question.reward&.update(user: answer.author)
    end
  end

  private

  def publish_answer
    return if answer.errors.any?
    ApplicationController.renderer.instance_variable_set(
      :@env, {
      "HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => warden
    }
    )
    ActionCable.server.broadcast(
      "questions/#{answer.question_id}/answers",
      {
        answer: ApplicationController.render(partial: 'answers/answer', locals: { answer: answer }),
        answer_id: answer.id,
        answer_author_id: answer.author_id,
        question_author_id: answer.question.author_id
      }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
