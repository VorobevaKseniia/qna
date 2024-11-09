class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create

  after_action :publish_comment, only: [:create]
  authorize_resource

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = @commentable

    if @comment.save
      head :created
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def commentable_type
    @commentable.class.name
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    else params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_for_#{commentable_type}_#{@commentable.id}", @comment)
  end
end
