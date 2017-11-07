module Pagination

  def limit_param(min=10, max=200)
    (params[:limit] || 100).to_i.clamp(10, 200)
  end

  def offset_param
    (params[:offset] || 0).to_i.tap do |offset|
      offset = 0 if offset < 0
    end
  end
end
