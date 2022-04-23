shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      send method, api_path
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      send method, api_path, params: { access_token: '1234' }
      expect(response.status).to eq 401
    end
  end
end
