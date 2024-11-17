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
    model = SEARCHABLE_SCOPES[scope]
    model ? model.search_by(query) : []
  end

  def search_all(query)
    SEARCHABLE_SCOPES.values.flat_map { |model| model.search_by(query) }
  end
end
