# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_user, only: %i[new create]
  before_action :find_question, only: %i[show edit update destroy remove_file]

  after_action :publish_question, only: [:create]
  authorize_resource
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
    @answer.links.new
    gon.question_id = @question.id
    gon.current_user = current_user
    @comment = Comment.new
  end

  def new
    @question = @user.questions.new
    @question.links.new
    @question.build_award
  end

  def edit; end

  def create
    @question = @user.questions.new(question_params)
    if @question.save
      @question.subscriptions.create(user: @user)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to user_questions_path(current_user), notice: 'Your question successfully deleted.'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url],
                                     award_attributes: [:title, :image])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', @question)
  end
end
