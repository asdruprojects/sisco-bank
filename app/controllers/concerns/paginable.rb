module Paginable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 20

  private

  def paginate(relation)
    per_page = DEFAULT_PER_PAGE

    total_count = relation.count
    total_pages = total_count.zero? ? 1 : (total_count.to_f / per_page).ceil
    page = [ params[:page].to_i, 1 ].max
    page = [ page, total_pages ].min

    @pagination = {
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: total_pages
    }

    relation.limit(per_page).offset((page - 1) * per_page)
  end
end
