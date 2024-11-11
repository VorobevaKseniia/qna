class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show]
  authorize_resource

  def index
    question = Question.find(params[:question_id])
    render json: question.answers , each_serializer: AnswerListSerializer
  end

  def show
    render json: @answer
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:question).permit(:title, :body)
  end
end