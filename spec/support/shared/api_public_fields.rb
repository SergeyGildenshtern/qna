shared_examples_for 'API public fields' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(json_response[attr]).to eq obj.send(attr).as_json
    end
  end
end
