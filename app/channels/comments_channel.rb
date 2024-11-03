class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_for_#{params[:commentable_type]}_#{params[:commentable_id]}"
  end

  def unsubscribed
  end

end
