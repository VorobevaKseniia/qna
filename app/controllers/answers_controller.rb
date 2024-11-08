# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[mark_as_best show edit update destroy remove_file]
  before_action :set_comment, only: %i[edit update mark_as_best]

  after_action :publish_answer, only: [:create]
  authorize_resource
  def new
    @answer = current_user.answers.new(question: @question)
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      head :created
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def mark_as_best
    if current_user.author?(@answer.question)
      @answer.mark_as_best
      @question = @answer.question
      @question.award.update(user_id: @answer.user_id)
    end
  end

  def show; end

  def edit; end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def set_comment
    @comment = Comment.new
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question_id}", @answer)
  end
end
