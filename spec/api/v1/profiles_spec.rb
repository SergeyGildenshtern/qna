require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }
  let!(:me) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:user_json) { json['user'] }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:json_response) { user_json }
        let(:obj) { me }
      end

      it_behaves_like 'API private fields' do
        let(:private_fields) { %w[password encrypted_password] }
        let(:json_response) { user_json }
      end
    end
  end

  describe 'GET /api/v1/profiles/other' do
    let(:api_path) { '/api/v1/profiles/other' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user_json) { json['users'].first }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of users' do
        expect(json['users'].size).to eq 2
      end

      it 'returns list of users without an authenticated user' do
        json['users'].each do |u|
          expect(u['id']).to_not eq me.id
        end
      end

      it_behaves_like 'API public fields' do
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:json_response) { user_json }
        let(:obj) { user }
      end

      it_behaves_like 'API private fields' do
        let(:private_fields) { %w[password encrypted_password] }
        let(:json_response) { user_json }
      end
    end
  end
end
