class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[ new create ]
  before_action :find_answer, only: %i[ show edit update destroy ]
  def new
    @answer = current_user.answers.new(question: @question)
  end

  def show
  end

  def edit
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer successfully created.'
    else
      render 'questions/show', question_id: @question
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
