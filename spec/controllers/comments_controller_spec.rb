require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'Question' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect {
            post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :json
          }.to change(question.comments, :count).by(1)
        end

        it 'returns status :created' do
          post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id }, format: :json
          }.not_to change(Comment, :count)
        end

        it 'returns status :unprocessable_entity' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'Answer' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect {
            post :create, params: { comment: attributes_for(:comment), answer_id: answer.id }, format: :json
          }.to change(answer.comments, :count).by(1)
        end

        it 'returns status :created' do
          post :create, params: { comment: attributes_for(:comment), answer_id: answer.id }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect {
            post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer.id }, format: :json
          }.not_to change(Comment, :count)
        end

        it 'returns status :unprocessable_entity' do
          post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer.id }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
