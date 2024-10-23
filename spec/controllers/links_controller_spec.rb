require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  before { login(user) }

  describe 'DELETE #destroy' do
    context 'Question' do
      it 'deletes the link' do
        expect { delete :destroy, params: { id: question_link.id }, format: :js }
          .to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question_link.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Answer' do
      it 'deletes the link' do
        expect { delete :destroy, params: { id: answer_link.id }, format: :js }
          .to change(answer.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer_link.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
