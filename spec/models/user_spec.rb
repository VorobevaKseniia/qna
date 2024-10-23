# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:author) { create(:user) }
    let(:non_author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    context 'when user is the author of object' do
      it 'returns true' do
        expect(author.author?(question)).to eq true
        expect(author.author?(answer)).to eq true
      end
    end

    context 'when user is not author of object' do
      it 'returns false' do
        expect(non_author.author?(question)).to eq false
        expect(non_author.author?(answer)).to eq false
      end
    end
  end
end
