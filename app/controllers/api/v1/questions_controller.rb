class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionListSerializer
  end

  def show
    render json: @question
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
