class NotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    NotificationService.new.send_notify question
  end
end
