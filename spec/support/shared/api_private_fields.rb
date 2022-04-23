shared_examples_for 'API private fields' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'does not return private fields' do
    private_fields.each do |attr|
      expect(json_response).to_not have_key(attr)
    end
  end
end
