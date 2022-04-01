require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  before { login(user) }

  describe "POST #vote" do
    context 'not author of votable' do
      it 'save the vote' do
        expect {
          post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        }.to change(answer.votes, :count).by(1)
      end

      it 'delete the vote' do
        answer.votes.create(user:user, status: true)
        expect {
          post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        }.to change(answer.votes, :count).by(-1)
      end

      it 'returns a 200 OK status' do
        post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'author of votable' do
      let!(:answer) { create(:answer, author: user) }

      it 'does not save the vote' do
        expect {
          post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        }.to_not change(answer.votes, :count)
      end

      it 'does not delete the vote' do
        answer.votes.create(user:user, status: true)
        expect {
          post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        }.to_not change(answer.votes, :count)
      end

      it 'returns a 403 forbidden status' do
        post :vote, params: { votable_id: answer, votable: answer.class.name, status: true }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
