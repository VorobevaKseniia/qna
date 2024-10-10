# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[mark_as_best show edit update destroy remove_file]
  def new
    @answer = current_user.answers.new(question: @question)
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def mark_as_best
    if current_user.author?(@answer.question)
      @answer.mark_as_best
      @question = @answer.question
    end
  end

  def show; end

  def edit; end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def remove_file
    file = @answer.files.find(params[:file_id])
    file.purge if current_user.author?(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
