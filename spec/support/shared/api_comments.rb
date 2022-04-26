shared_examples_for 'API Commentable' do
  it 'returns list of comments' do
    expect(json_comments.size).to eq 2
  end

  it 'returns all public fields' do
    %w[id text author_id created_at updated_at].each do |attr|
      expect(json_comments.first[attr]).to eq comment.send(attr).as_json
    end
  end
end
