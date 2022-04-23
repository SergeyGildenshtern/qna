require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}
  let!(:access_token) { create(:access_token) }
  let(:user_id) { access_token.resource_owner_id }
  let(:json_question) { json['question'] }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:questions) { create_list(:question, 2) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 2, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }

      before do
        question.files.attach([create_file_blob, create_file_blob])
        get api_path, params: {access_token: access_token.token}, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(json_question[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like 'API Commentable' do
        let(:comment) { comments.first }
        let(:json_comments) { json_question['comments'] }
      end

      it_behaves_like 'API Linkable' do
        let(:link) { links.first }
        let(:json_links) { json_question['links'] }
      end

      it_behaves_like 'API Filable' do
        let(:file) { question.files.first }
        let(:json_files) { json_question['files'] }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid question attributes' do
        before { post api_path, params: { question: attributes_for(:question), access_token: access_token.token } }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'saves a new question in the database' do
          expect(Question.count).to eq 1
        end

        it 'render json question' do
          %w[id title body author_id created_at updated_at].each do |attr|
            expect(json_question[attr]).to eq Question.last.send(attr).as_json
          end
        end
      end

      context 'invalid question attributes' do
        before { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token } }

        it 'returns a 403 forbidden status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save the question in the database' do
          expect(Question.count).to eq 0
        end

        it 'render json question errors' do
          expect(json['body']).to eq ["can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question, author_id: user_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'valid question attributes' do
        before { patch api_path, params: { question: { body: 'Question body' }, access_token: access_token.token } }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'changes question attributes' do
          question.reload
          expect(question.body).to eq 'Question body'
        end

        it 'render json question' do
          question.reload
          %w[id title body author_id created_at updated_at].each do |attr|
            expect(json_question[attr]).to eq question.send(attr).as_json
          end
        end
      end

      context 'invalid question attributes' do
        before { patch api_path, params: { question: { body: nil }, access_token: access_token.token } }

        it 'returns a 403 forbidden status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change question attributes' do
          question.reload
          expect(question.body).to_not eq nil
        end

        it 'render json question errors' do
          expect(json['body']).to eq ["can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, author_id: user_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before { delete api_path, params: { access_token: access_token.token } }

      it 'deletes the question' do
        expect(Question.count).to eq 0
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end
    end
  end
end
