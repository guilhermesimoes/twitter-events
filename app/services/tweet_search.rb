class TweetSearch
  attr_reader :query, :page

  def initialize(query, page)
    @query = query
    @page = page || 1
  end

  def search
    search = Tweet.search(:include => [:user, :place]) do
      fulltext query do
        highlight :text
      end
      paginate :page => page
      order_by :created_at, :desc
    end

    search.hits.each do |hit|
      hit.result.text = hit.highlights(:text).first.format
    end

    search
  end
end
