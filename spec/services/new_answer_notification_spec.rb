require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:service) { Services::NewAnswerNotification.new(answer) }
  let(:mailer) { double("DailyDigestMailer") }

  before do
    question.subscriptions.create(user: user)
    allow(DailyDigestMailer).to receive(:with).with(user: user, answer: answer).and_return(mailer)
    allow(mailer).to receive(:new_answer).and_return(mailer)
    allow(mailer).to receive(:deliver_later)
  end

  it 'sends notification to all subscribers of the question' do
    service.send_notifications

    expect(DailyDigestMailer).to have_received(:with).with(user: user, answer: answer)
    expect(mailer).to have_received(:new_answer)
    expect(mailer).to have_received(:deliver_later)
  end
end
