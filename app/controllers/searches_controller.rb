class SearchesController < ApplicationController
  SEARCHABLE_SCOPES = {
    'Questions' => Question,
    'Answers' => Answer,
    'Comments' => Comment,
    'Users' => User
  }.freeze

  authorize_resource class: false

  def index
    @query = params[:query]
    @scope = params[:scope]
    @result = if @query.blank?
                []
              elsif @scope == 'All'
                search_all(@query)
              else
                search_by_scope(@scope, @query)
              end
  end

  private

  def search_by_scope(scope, query)
    Rails.logger.debug "Search by scope called with scope: #{scope}, query: #{query}"
    model = SEARCHABLE_SCOPES[scope]
    results = model ? model.search_by(query) : []
    Rails.logger.debug "Search by scope results: #{results}"
    results
  end

  def search_all(query)
    Rails.logger.debug "Search all called with query: #{query}"
    results = SEARCHABLE_SCOPES.values.flat_map { |model| model.search_by(query) }
    Rails.logger.debug "Search all results: #{results}"
    results
  end
end
