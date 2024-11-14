require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  subject { create(:subscription, user: user, question: question) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
