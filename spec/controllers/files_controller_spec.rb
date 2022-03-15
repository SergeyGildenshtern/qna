require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  before { login(user) }

  describe 'DELETE #destroy' do
    context 'author of record' do
      let(:answer) { create(:answer, question: question, author: user) }

      before { answer.files.attach(create_file_blob) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: answer.files.last }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'renders delete view' do
        delete :destroy, params: { id: answer.files.last }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      let(:answer) { create(:answer, question: question) }

      before { answer.files.attach(create_file_blob) }

      it 'does not deletes the file' do
        expect { delete :destroy, params: { id: answer.files.last }, format: :js }.to_not change(answer.files, :count)
      end

      it 'renders delete view' do
        delete :destroy, params: { id: answer.files.last }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
