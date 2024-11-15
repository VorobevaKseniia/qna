class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  authorize_resource

  def create
    subscription = @question.subscriptions.create(user: current_user)
    render json: { subscribed: true, subscription_id: subscription.id,
                   message: 'You have subscribed to updates for this question.' }
  end

  def destroy
    subscription = Subscription.find(params[:id])
    subscription.destroy
    render json: { subscribed: false,
                   message: 'You have unsubscribed from updates for this question.' }
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
