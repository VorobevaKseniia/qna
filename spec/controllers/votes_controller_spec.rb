require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }

  shared_examples 'votable tests' do |votable_name|
    let(:votable) { send(votable_name) }

    describe 'POST #vote' do
      context 'if vote new' do
        context 'user is author of question' do
          before { login(author) }

          it 'does not save a new vote in the database' do
            expect {
              post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            }.to change(votable.votes, :count).by(0)
          end

          it 'returns status :unprocessable_entity' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'user is not author of question' do
          before { login(user) }

          it 'saves a new vote in the database' do
            expect {
              post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            }.to change(votable.votes, :count).by(1)
          end

          it 'returns status :created' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            expect(response).to have_http_status(:created)
          end

          it 'returns the created vote as JSON' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json

            expect(JSON.parse(response.body)['id']).to eq(Vote.last.id)
            expect(JSON.parse(response.body)['value']).to eq(Vote.last.value)
          end
        end
      end

      context 'if vote exist' do
        before do
          login(user)
          votable.votes.create(user: user, value: 1)
        end

        context 'update' do
          it "changes vote's value" do
            expect {
              post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: -1 }, format: :json
            }.not_to change(question.votes, :count)
            expect(votable.votes.find_by(user: user).value).to eq(-1)
          end

          it 'returns status :ok' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: -1 }, format: :json
            expect(response).to have_http_status(:ok)
          end

          it 'returns the updated vote as JSON' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: -1 }, format: :json
            expect(JSON.parse(response.body)['value']).to eq(-1)
          end
        end

        context 'destroy' do
          it 'deletes the vote' do
            expect {
              post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            }.to change(Vote, :count).by(-1)
          end

          it 'returns status :ok' do
            post :vote, params: { votable_type: votable.class.name, votable_id: votable.id, value: 1 }, format: :json
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end
  include_examples 'votable tests', :question
  include_examples 'votable tests', :answer
end
