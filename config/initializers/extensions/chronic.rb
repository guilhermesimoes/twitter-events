module Chronic
  class Span < Range
    def initialize(_begin, _end, exclude_end = true)
      super(_begin, _end, exclude_end)
    end
  end
end
