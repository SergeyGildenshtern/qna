require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create,
               params: { answer: attributes_for(:answer), question_id: question },
               format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question },
               format: :js
        }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      let!(:answer) { create(:answer) }

      it 'does not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PUT #update_best' do
    context 'author of question' do
      let(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }

      it 'changes answer attribute' do
        expect { put :update_best, params: { id: answer }, format: :js }.to change(question, :best_answer).from(nil).to(answer)
      end

      it 'renders update_best view' do
        put :update_best, params: { id: answer }, format: :js
        expect(response).to render_template :update_best
      end
    end

    context 'not author of question' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not changes answer attribute' do
        expect { put :update_best, params: { id: answer }, format: :js }.to_not change(question, :best_answer)
      end

      it 'renders update_best view' do
        put :update_best, params: { id: answer }, format: :js
        expect(response).to render_template :update_best
      end
    end
  end
end
