class SearchesController < ApplicationController
  authorize_resource class: false

  def index
    @query = params[:query]
    @scope = params[:scope]
    @result = Services::Search.new(@query, @scope).perform
  end
end
