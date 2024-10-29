class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable, only: %i[create destroy]
  before_action :find_vote, only: :destroy

  def create
    @vote = @votable.votes.find_or_initialize_by(user: current_user)
    if !current_user.author?(@votable)
      if @vote.value != params[:value].to_i
        @vote.value = params[:value]
        if @vote.save
          render json: { id: @vote.id,
                         value: @vote.value,
                         votable_id: @votable.id,
                         rating: @votable.rating,
                         likes: @votable.votes.where(value: 1).count,
                         dislikes: @votable.votes.where(value: -1).count },
                 status: :created
        end
      else
        destroy
      end
    end
  end

  def destroy
    @vote.destroy
    render json: { votable_id: @votable.id,
                   rating: @votable.rating,
                   likes: @votable.votes.where(value: 1).count,
                   dislikes: @votable.votes.where(value: -1).count },
           status: :ok
  end

  private

  def find_votable
    @votable = params[:votable_type].constantize.find(params[:votable_id])
  end

  def find_vote
    @vote = Vote.find(params[:id])
  end
end
