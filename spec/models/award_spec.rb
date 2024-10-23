require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image }
  it { should have_one_attached(:image) }
end