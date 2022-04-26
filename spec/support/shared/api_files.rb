shared_examples_for 'API Filable' do
  it 'returns list of files' do
    expect(json_files.size).to eq 2
  end

  it 'returns all public fields' do
    %w[id created_at].each do |attr|
      expect(json_files.first[attr]).to eq file.send(attr).as_json
    end
  end

  it 'contains url to file' do
    expect(json_files.first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end
end
