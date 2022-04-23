require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other_user) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other_user) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: other_user) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other_user) }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: other_user) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it do
      question.files.attach(create_file_blob)
      should be_able_to :destroy, question.files.last
    end

    it do
      other_question.files.attach(create_file_blob)
      should_not be_able_to :destroy, other_question.files.last
    end

    it { should be_able_to :vote, other_question }
    it { should_not be_able_to :vote, question }

    it { should be_able_to :vote, create(:answer, author: other_user) }
    it { should_not be_able_to :vote, create(:answer, author: user) }

    it { should be_able_to :update_best, create(:answer, question: question) }
    it { should_not be_able_to :update_best, create(:answer, question: other_question) }

    it { should be_able_to :me, User }
    it { should be_able_to :other, User }
  end
end
