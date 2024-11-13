# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:award).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it{ should accept_nested_attributes_for :links }

  it { should have_many_attached(:files) }

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
