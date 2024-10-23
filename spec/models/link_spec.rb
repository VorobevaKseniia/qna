require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value(URI.regexp).for(:url) }

  let!(:user) { create :user }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:link_question) { create(:link, linkable: question, name: "gist", url: "https://gist.github.com/VorobevaKseniia/2971a1aa4a7d0b30e1d3b1b66f79d9f3") }
  let!(:link_answer) { create(:link, linkable: answer, name: "gist", url: "https://gist.github.com/VorobevaKseniia/2971a1aa4a7d0b30e1d3b1b66f79d9f3") }

  describe '#gist?' do
    context 'Question' do
      it 'return true if link is gist' do
        expect(link_question.gist?).to eq true
      end
    end

    context 'Answer' do
      it 'return true if link is gist' do
        expect(link_answer.gist?).to eq true
      end
    end
  end
end
