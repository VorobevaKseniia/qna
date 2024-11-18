class Services::Search

  def initialize(query, scope)
    @query = query
    @scope = scope
  end

  def perform
    return [] if @query.blank?

    if @scope == 'All'
      search_all
    else
      search_by_scope
    end
  end

  private

  def search_by_scope
    model = @scope.singularize.constantize
    model ? model.search_by(@query) : []
  end

  def search_all
    models = ActiveRecord::Base.descendants.select { |model| model.respond_to?(:search_by) }
    models.flat_map { |model| model.search_by(@query) }.compact
  end
end
