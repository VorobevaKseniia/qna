# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it{ should accept_nested_attributes_for :links }
  it { should have_many_attached(:files) }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

  describe '#sort_by_best' do
    it 'sorts the answers by best' do
      sorted_answers = question.answers.sort_by_best
      expect(sorted_answers.first).to eq best_answer
      expect(sorted_answers.size).to eq question.answers.size
    end
  end

  describe '#mark_as_best' do
    it 'marks only one answer as best' do
      question.answers.first.mark_as_best

      expect(question.answers.first.best).to eq true
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
end
