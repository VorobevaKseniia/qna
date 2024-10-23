require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:award_1) { create(:award, image: fixture_file_upload("#{Rails.root}/app/assets/images/award.png"),
                          question: question, user: user) }
  let(:award_2) { create(:award, image: fixture_file_upload("#{Rails.root}/app/assets/images/award.png"),
                         question: question, user: user) }

  describe 'GET #index' do
    before do
      login(user)
      get :index, params: { user_id: user.id }
    end

    it 'populates an array of all rewards' do
      expect(assigns(:awards)).to match_array([award_1, award_2])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
