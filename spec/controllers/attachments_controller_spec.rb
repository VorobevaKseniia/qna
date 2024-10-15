require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

  before do
    login(user)
    question.files.attach(file)
    answer.files.attach(file)
  end

  describe 'DELETE #destroy' do
    context 'Question' do
      it 'deletes the file' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }
          .to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Answer' do
      it 'deletes the file' do
        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }
          .to change(answer.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
