require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { is_expected.to validate_url_of(:url) }

  describe 'Checking the URL on gist' do
    let(:question) { create(:question) }
    let(:gist_link) { create(:link, url: 'https://gist.github.com/SergeyGildenshtern/446ad7c8d50ff0b73cc99e8df690433c', linkable: question) }
    let(:other_link) { create(:link, linkable: question) }

    it 'URL is gist' do
      expect(gist_link).to be_gist
    end

    it 'URL is not gist' do
      expect(other_link).to_not be_gist
    end
  end
end
