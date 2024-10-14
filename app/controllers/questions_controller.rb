# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_user, only: %i[new create]
  before_action :find_question, only: %i[show edit update destroy remove_file]
  def index
    @questions = Question.all
    flash[:notion] = 'You need to sign in to write a question' unless user_signed_in?
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = @user.questions.new
  end

  def edit; end

  def create
    @question = @user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to user_questions_path(current_user), notice: 'Your question successfully deleted.'
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
