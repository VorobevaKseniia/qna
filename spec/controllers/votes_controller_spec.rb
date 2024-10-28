require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'POST #create' do
    before { login(user) }

    context 'if vote new' do
      it 'saves a new vote in the database' do
        expect {
          post :create, params: { votable_type: 'Question', votable_id: question.id, value: 1 }, format: :json
        }.to change(question.votes, :count).by(1)
      end

      it 'returns status :created' do
        post :create, params: { votable_type: 'Question', votable_id: question.id, value: 1 }, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'returns the created vote as JSON' do
        post :create, params: { votable_type: 'Question', votable_id: question.id, value: 1 }, format: :json

        expect(JSON.parse(response.body)['id']).to eq(Vote.last.id)
        expect(JSON.parse(response.body)['value']).to eq(Vote.last.value)
      end
    end

    context 'if vote exist' do
      before { question.votes.create(user: user, value: 1) }

      it "changes vote's value" do
        expect {
          post :create, params: { votable_type: 'Question', votable_id: question.id, value: -1 }, format: :json
        }.not_to change(question.votes, :count)
        expect(question.votes.find_by(user: user).value).to eq(-1)
      end

      it 'returns status :created' do
        post :create, params: { votable_type: 'Question', votable_id: question.id, value: -1 }, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'returns the updated vote as JSON' do
        post :create, params: { votable_type: 'Question', votable_id: question.id, value: -1 }, format: :json
        expect(JSON.parse(response.body)['value']).to eq(-1)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:vote) { create(:vote, votable_type: 'Question', votable_id: question.id) }

    it 'deletes the vote' do
      expect { delete :destroy, params: { id: vote, votable_type: 'Question', votable_id: question.id },
                      format: :json }.to change(Vote, :count).by(-1)
    end
  end
end
