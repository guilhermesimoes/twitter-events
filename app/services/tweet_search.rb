class TweetSearch
  attr_reader :query, :page

  def initialize(query, page)
    @query = query
    @page = page || 1
  end

  def search
    Tweet.search(:include => [:user, :place]) do
      fulltext query do
        highlight :text
      end
      paginate :page => page
      order_by :created_at, :desc
    end
  end
end
