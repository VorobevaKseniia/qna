require 'rails_helper'

RSpec.describe Services::Search do

  describe '#perform' do
    let(:query) { 'My' }
    let(:scope) { 'Question' }
    let(:service) { described_class.new(query, scope) }

    context '#search_by_scope' do
      it 'calls search_by on the specified model' do
        expect(Question).to receive(:search_by).with(query).and_return([:result])
        expect(service.perform).to eq([:result])
      end
    end

    context 'with empty query' do
      let(:query) { '' }

      it 'returns an empty array' do
        expect(service.perform).to eq([])
      end
    end

    context '#search_all' do
      let(:scope) { 'All' }

      it 'searches across all searchable models' do
        allow(ActiveRecord::Base).to receive(:descendants).and_return([Question, Answer, Comment, User])
        allow(Question).to receive(:search_by).with(query).and_return([:question_result])
        allow(Answer).to receive(:search_by).with(query).and_return([:answer_result])
        allow(Comment).to receive(:search_by).with(query).and_return([:comment_result])
        allow(User).to receive(:search_by).with(query).and_return([:user_result])

        expect(service.perform).to match_array([:question_result, :answer_result, :comment_result, :user_result])
      end
    end
  end
end
