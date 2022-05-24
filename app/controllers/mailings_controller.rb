class MailingsController < ApplicationController
  before_action :authenticate_user!

  expose :mailing, build: ->{ current_user.mailings.new(question: question) }
  expose :question

  def create
    authorize! :subscribe, question
    mailing.save
  end

  def destroy
    authorize! :unsubscribe, mailing.question
    mailing.destroy
  end
end
