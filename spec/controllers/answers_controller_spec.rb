require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question.id }  }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id, user_id: user.id}
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to question_path view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id, user_id: user.id }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id, user_id: user.id }
        }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, question: question, user: user), question_id: question.id }
        expect(response).to render_template "questions/show", question_id: question
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer } }

    it 'assigns the requested Answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer),
                                 question: question, user: user }
        expect(assigns(:answer)).to eq answer
      end

      it "changes answer's attributes" do
        patch :update, params: { id: answer, answer: { body: 'new body' },
                                 question: question, user: user }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question_path with updated data' do
        patch :update, params: { id: answer, answer: attributes_for(:answer),
                                 question: question, user: user }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid),
                                        question: question, user: user}}
      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:non_author) { create(:user) }

    context 'when user is the author of the answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
    end

    context 'when user is not the author of the answer' do
      it 'does not destroy the answer if user_id is wrong' do
        login(non_author)
        expect { delete :destroy, params: { id: answer} }.to change(Answer, :count).by(0)
      end
    end

    it 'redirects to question_path' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end
end
