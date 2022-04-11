require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe 'Getting the user vote' do
    let(:user) { create(:user) }
    let!(:model1) { create(described_class.to_s.underscore) }
    let!(:model2) { create(described_class.to_s.underscore) }
    let!(:vote) { create(:vote, user: user, votable: model2) }

    it 'user is not vote' do
      expect(model1.vote(user)).to eq nil
    end

    it 'user is vote' do
      expect(model2.vote(user)).to eq vote
    end
  end

  describe 'Checking the user vote' do
    let(:user) { create(:user) }
    let(:model) { create(described_class.to_s.underscore) }

    it 'user is not vote' do
      expect(model).to_not be_voted(user)
    end

    it 'user is vote' do
      model.votes.create(user: user, status: 1)
      expect(model).to be_voted(user)
    end
  end

  describe 'Getting the votable rating' do
    let!(:model) { create(described_class.to_s.underscore) }
    let!(:vote1) { create(:vote, votable: model, user: create(:user), status: -1) }
    let!(:vote2) { create(:vote, votable: model, user: create(:user), status: -1) }

    it "returns a number, the difference between 'for' and 'against'" do
      expect(model.rating).to eq -2
    end
  end
end
