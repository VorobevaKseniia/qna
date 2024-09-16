class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :find_user, only: [:new, :create]
  before_action :find_question, only: %i[show edit update destroy]
  def index
    @questions = Question.all
    flash[:notion] = 'You need to sign in to write a question' if !user_signed_in?
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = @user.questions.new
    @user = current_user
  end

  def edit
  end

  def create
    @question = @user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy if current_user.author?(@question)
    redirect_to user_questions_path(current_user), notice: 'Your question successfully deleted.'
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
