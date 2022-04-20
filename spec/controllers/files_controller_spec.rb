require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:question) { create(:question) }
  let(:file) { question.files.last }

  before { question.files.attach(create_file_blob) }

  describe 'DELETE #destroy' do
    context 'author of record' do
      before { login(question.author) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders delete view' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      before { login(create(:user)) }

      it 'does not deletes the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(question.files, :count)
      end

      it 'returns a 403 forbidden status' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
