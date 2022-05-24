require 'rails_helper'

RSpec.describe MailingsController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  before { login(user) }

  describe 'POST #create' do
    it 'saves the new mailing in the database' do
      expect {
        post :create, params: { question_id: question }, format: :js
      }.to change(user.mailings, :count).by(1)
    end

    it 'renders create template' do
      post :create, params: { question_id: question }, format: :js
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    let!(:mailing) { create(:mailing, question: question, user: user) }

    it 'deletes the mailing' do
      expect {
        delete :destroy, params: { id: mailing.id }, format: :js
      }.to change(user.mailings, :count).by(-1)
    end

    it 'renders destroy template' do
      delete :destroy, params: { id: mailing.id }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
