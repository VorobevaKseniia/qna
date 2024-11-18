require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let!(:user) { create(:user, email: 'my_user@example.com') }
  let!(:question) { create(:question, title: 'My question', body: 'My question body', user: user) }
  let!(:answer) { create(:answer, body: 'My answer body', question: question, user: user) }
  let!(:comment) { create(:comment, body: 'My comment body', commentable: question, user: user) }

  before { login(user) }

  describe 'GET #index' do
    context 'with valid query' do
      before do
        allow(Services::Search).to receive(:new).with('My', nil)
                                     .and_return(double(perform: [question, answer, comment, user]))
        get :index, params: { query: 'My' }
      end

      it 'initializes the search service with correct parameters' do
        expect(Services::Search).to have_received(:new).with('My', nil)
      end

      it 'assigns the result of the search to @result' do
        expect(assigns(:result)).to match_array([question, answer, comment, user])
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with empty query' do
      before do
        allow(Services::Search).to receive(:new).with('', nil)
                                     .and_return(double(perform: []))
        get :index, params: { query: '' }
      end

      it 'initializes the search service with correct parameters' do
        expect(Services::Search).to have_received(:new).with('', nil)
      end

      it 'assigns an empty result to @result' do
        expect(assigns(:result)).to be_empty
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with type-specific query' do
      before do
        allow(Services::Search).to receive(:new).with('My', 'Question')
                                     .and_return(double(perform: [question]))
        get :index, params: { query: 'My', scope: 'Question' }
      end

      it 'searches only questions when scope is Question' do
        expect(assigns(:result)).to match_array([question])
      end

      it 'initializes the search service with correct parameters' do
        expect(Services::Search).to have_received(:new).with('My', 'Question')
      end
    end
  end
end
