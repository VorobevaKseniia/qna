class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:update, :destroy]
  authorize_resource

  def index
    question = Question.find(params[:question_id])
    render json: question.answers
  end

  def show
    render json: Answer.find(params[:id])
  end

  def create
    question = Question.find(params[:question_id])
    answer = current_resource_owner.answers.new(answer_params)
    answer.question = question

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: { message: 'Answer deleted successfully' }, status: :ok
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
