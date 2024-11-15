class Services::NewAnswerNotification
  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def send_notifications
    @question.subscribers.find_each do |user|
      DailyDigestMailer.with(user: user, answer: @answer).new_answer.deliver_later
    end
  end
end
