require 'rails_helper'

RSpec.describe Ability, type: :model do
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
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user)}
    let(:answer) { create(:answer, user: other, question: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all}

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, user: user, question: question), user: user }
    it { should_not be_able_to :update, create(:answer, user: other, question: question), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, user: user, question: question), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other, question: question), user: user }

    it { should be_able_to :destroy, create(:link, linkable: question), user: user }

    it 'allows the user to destroy their own attachments' do
      question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
      attachment = question.files.first
      expect(ability).to be_able_to(:destroy, attachment)
    end

    context 'when user is the author of the question' do
      it { should be_able_to :mark_as_best, answer, user: user }
    end

    context 'other' do
      subject(:ability) { Ability.new(other) }
      context 'when user is not the author of the resource' do
        it { should_not be_able_to :mark_as_best, answer, user: other }

        it { should be_able_to :vote, create(:question, user: user), user: other }
        it { should be_able_to :vote, create(:answer, user: user, question: question), user: other }
      end

      context 'when user is the author of the resource' do
        it { should_not be_able_to :vote, create(:question, user: other), user: other }
        it { should_not be_able_to :vote, create(:answer, user: other, question: question), user: other}
      end
    end
  end
end
