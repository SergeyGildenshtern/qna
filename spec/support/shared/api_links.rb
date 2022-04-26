shared_examples_for 'API Linkable' do
  it 'returns list of links' do
    expect(json_links.size).to eq 2
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |attr|
      expect(json_links.first[attr]).to eq link.send(attr).as_json
    end
  end
end
