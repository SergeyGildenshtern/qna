require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:question) { create(:question) }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService#send_notify' do
    expect(service).to receive(:send_notify).with(question)
    NotificationJob.perform_now(question)
  end
end
