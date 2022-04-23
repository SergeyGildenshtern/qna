require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}
  let(:access_token) { create(:access_token) }
  let(:user_id) { access_token.resource_owner_id }
  let(:json_answer) { json['answer'] }

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, question: create(:question)) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }

      before do
        answer.files.attach([create_file_blob, create_file_blob])
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id body author_id best created_at updated_at] }
        let(:json_response) { json_answer }
        let(:obj) { answer }
      end

      it_behaves_like 'API Commentable' do
        let(:comment) { comments.first }
        let(:json_comments) { json_answer['comments'] }
      end

      it_behaves_like 'API Linkable' do
        let(:link) { links.first }
        let(:json_links) { json_answer['links'] }
      end

      it_behaves_like 'API Filable' do
        let(:file) { answer.files.first }
        let(:json_files) { json_answer['files'] }
      end
    end
  end

  describe 'GET /questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:json_answer) { json['answers'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id body author_id best created_at updated_at] }
        let(:json_response) { json_answer }
        let(:obj) { answer }
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid answer attributes' do
        before { post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token } }

        it 'saves a new answer in the database' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'API public fields' do
          let(:public_fields) { %w[id body author_id best created_at updated_at] }
          let(:json_response) { json_answer }
          let(:obj) { Answer.last }
        end
      end

      context 'invalid answer attributes' do
        before { post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

        it 'returns a 403 forbidden status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save the answer in the database' do
          expect(Answer.count).to eq 0
        end

        it 'render json answer errors' do
          expect(json['body']).to eq ["can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer, author_id: user_id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'valid answer attributes' do
        before do
          patch api_path, params: { answer: { body: 'Answer body' }, access_token: access_token.token }
          answer.reload
        end

        it 'changes answer attributes' do
          expect(answer.body).to eq 'Answer body'
        end

        it_behaves_like 'API public fields' do
          let(:public_fields) { %w[id body author_id best created_at updated_at] }
          let(:json_response) { json_answer }
          let(:obj) { answer }
        end
      end

      context 'invalid answer attributes' do
        before { patch api_path, params: { answer: { body: nil }, access_token: access_token.token } }

        it 'returns a 403 forbidden status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to_not eq nil
        end

        it 'render json answer errors' do
          expect(json['body']).to eq ["can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, author_id: user_id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before { delete api_path, params: { access_token: access_token.token } }

      it 'deletes the answer' do
        expect(Answer.count).to eq 0
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end
    end
  end
end
