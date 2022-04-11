require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }

    before { login(user) }

    describe 'with valid attributes' do
      it 'saves the new comment in the database' do
        expect {
          post :create,
               params: { comment: attributes_for(:comment), commentable_type: question.class.to_s, commentable_id: question.id },
               format: :js
        }.to change(Comment, :count).by(1)
      end

      it 'renders create template' do
        post :create,
             params: { comment: attributes_for(:comment), commentable_type: question.class.to_s, commentable_id: question.id },
             format: :js
        expect(response).to render_template :create
      end
    end

    describe 'with invalid attributes' do
      it 'does not save the comment' do
        expect {
          post :create,
               params: { comment: attributes_for(:comment, :invalid), commentable_type: question.class.to_s, commentable_id: question.id },
               format: :js
        }.to_not change(Comment, :count)
      end

      it 'renders create template' do
        post :create,
             params: { comment: attributes_for(:comment, :invalid), commentable_type: question.class.to_s, commentable_id: question.id },
             format: :js
        expect(response).to render_template :create
      end
    end
  end
end
