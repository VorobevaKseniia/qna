class LinksController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user.author?(@link.linkable)
  end
end
