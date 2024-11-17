require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let!(:user) { create(:user, email: 'my_user@example.com') }
  let!(:question) { create(:question, title: 'My question', body: 'My question body', user: user) }
  let!(:answer) { create(:answer, body: 'My answer body', question: question, user: user) }
  let!(:comment) { create(:comment, body: 'My comment body', commentable: question, user: user) }

  before { login(user) }

  describe 'GET #index' do
    context 'with valid query' do
      before { get :index, params: { query: 'My' } }

      it 'returns success response' do
        expect(response).to have_http_status(:success)
      end

      it 'finds the relevant resources' do
        expect(assigns(:result)).to match_array([question, answer, comment, user])
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with empty query' do
      before { get :index, params: { query: '' } }

      it 'returns empty results' do
        expect(assigns(:result)).to be_empty
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with type-specific query' do
      it 'searches only questions when type is question' do
        get :index, params: { query: 'My', type: 'Question' }
        expect(assigns(:result)).to match_array([question])
      end

      it 'searches only answers when type is answer' do
        get :index, params: { query: 'My', type: 'Answer' }
        expect(assigns(:result)).to match_array([answer])
      end

      it 'searches only comments when type is comment' do
        get :index, params: { query: 'My', type: 'Comment' }
        expect(assigns(:result)).to match_array([comment])
      end

      it 'searches only users when type is user' do
        get :index, params: { query: 'My', type: 'User' }
        expect(assigns(:result)).to match_array([user])
      end
    end
  end
end
