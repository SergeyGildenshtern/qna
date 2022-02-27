require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer, question: create(:question)) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let!(:answer) { create(:answer, question: create(:question)) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create, params: { question_id: answer.question,
                                  answer: attributes_for(:answer) } }.to change(answer.question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { question_id: answer.question,
                                  answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders question view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        body = answer.body
        answer.reload

        expect(answer.body).to eq body
      end

      it 're-renders question view' do
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'not author' do
      let!(:answer) { create(:answer) }

      it 'does not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
