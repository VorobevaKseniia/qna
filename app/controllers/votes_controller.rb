class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable
  before_action :check_author
  before_action :find_or_initialize_vote

  def vote
    if @vote.persisted?
      if @vote.value == params[:value].to_i
        @vote.destroy
        render_vote_response(status: :ok)
      else
        @vote.update(value: params[:value])
        render_vote_response(status: :ok)
      end
    else
      @vote.value = params[:value]
      if @vote.save
        render_vote_response(status: :created)
      end
    end
  end

  private

  def check_author
    return unless current_user.author?(@votable)

    render json: { error: "Author cannot vote for own #{@votable.class.name.downcase}" }, status: :unprocessable_entity
  end

  def find_or_initialize_vote
    @vote = @votable.votes.find_or_initialize_by(user: current_user)
  end

  def find_votable
    @votable = params[:votable_type].constantize.find(params[:votable_id])
  end

  def render_vote_response(status:)
    render json: { id: @vote&.id,
                   value: @vote&.value,
                   votable_id: @votable.id,
                   votable_type: @votable.class.name,
                   rating: @votable.rating,
                   likes: @votable.likes,
                   dislikes: @votable.dislikes },
           status: status
  end
end
