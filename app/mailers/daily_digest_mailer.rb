class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where(created_at: 1.day.ago.all_day)

    mail to: user.email, subject: 'New questions for today'
  end

  def new_answer(user, answer)
    @answer = answer
    @question = answer.question
    mail to: user.email, subject: 'New answer to your question'
  end
end
