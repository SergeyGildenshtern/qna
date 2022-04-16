require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create :user }

  before { login(user) }

  describe 'DELETE #destroy' do
    context 'author of linkable' do
      let(:question) { create :question, author: user }
      let!(:link) { create(:link, name: 'google', url: 'https://www.google.ru/', linkable: question) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders delete view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of linkable' do
      let(:question) { create :question}
      let!(:link) { create(:link, name: 'google', url: 'https://www.google.ru/', linkable: question) }

      it 'does not deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      end

      it 'renders delete view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
