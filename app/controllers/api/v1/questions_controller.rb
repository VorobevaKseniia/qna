class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:update, :destroy]
  authorize_resource

  def index
    render json: Question.all
  end

  def show
    render json: Question.with_attached_files.find(params[:id])
  end

  def create
    question = current_resource_owner.questions.new(question_params)

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: { message: 'Question deleted successfully' }, status: :ok
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
