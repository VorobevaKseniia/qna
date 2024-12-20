# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question.id } }

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
        expect { post :create,
                      params: { answer: attributes_for(:answer), question_id: question.id, user_id: user.id },
                      format: :json
        }.to change(question.answers, :count).by(1)
      end

      it 'returns status :created' do
        post :create,
             params: { answer: attributes_for(:answer), question_id: question.id, user_id: user.id },
             format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { answer: attributes_for(:answer, :invalid),
                                  question_id: question.id, user_id: user.id }, format: :json
        }.to_not change(Answer, :count)
      end

      it 'returns status :unprocessable_entity with errors' do
        post :create,
             params: { answer: attributes_for(:answer, :invalid), question_id: question.id, user_id: user.id },
             format: :json
        expect(response).to have_http_status(:unprocessable_entity)
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
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it "changes answer's attributes" do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer' do
        expect {patch :update,
                       params: { id: answer, answer: attributes_for(:answer, :invalid) },
                       format: :js}.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user ) }
    let!(:award) { create(:award, image: fixture_file_upload("#{Rails.root}/app/assets/images/award.png"),
                             question: question) }

    context 'when user is the author of the question' do
      it 'marks the answer as best' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        answer.reload
        award.reload
        expect(answer.best).to be true
        expect(question.answers.where(best: true).count).to eq 1
      end

      it 'redirects to the question page' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when user is not author of the question' do
      let!(:non_author) { create(:user) }
      before { login(non_author) }

      it 'does not mark the answer as best' do
        patch :mark_as_best, params: { id: answer.id }, format: :js
        answer.reload
        expect(answer.best).to be false
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:, user:) }
    let(:non_author) { create(:user) }

    context 'when user is the author of the answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'when user is not the author of the answer' do
      it 'does not destroy the answer if user is not the author' do
        login(non_author)
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end

    it 'render destroy' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
