require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    it 'creates a new subscription' do
      expect {
        post :create, params: { question_id: question.id }, format: :json
      }.to change(question.subscriptions, :count).by(1)
    end

    it 'assigns the subscription to the current user' do
      post :create, params: { question_id: question.id }, format: :json
      expect(question.subscriptions.last.user).to eq(user)
    end

    it 'returns a success JSON response with the correct message' do
      post :create, params: { question_id: question.id }, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['subscribed']).to be true
      expect(json_response['message']).to eq('You have subscribed to updates for this question.')
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'removes the subscription' do
      expect {
        delete :destroy, params: { id: subscription.id }, format: :json
      }.to change(question.subscriptions, :count).by(-1)
    end

    it 'returns a success JSON response with the correct message' do
      delete :destroy, params: { id: subscription.id }, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['subscribed']).to be false
      expect(json_response['message']).to eq('You have unsubscribed from updates for this question.')
    end
  end
end
