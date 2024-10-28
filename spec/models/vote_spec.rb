require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  subject { described_class.new(user: user, votable: question, value: 1) }

  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }
end
