class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question_id]}"
  end

  def unsubscribed; end
end
