class EventsSimilarityCalculator
  THRESHOLD = 0.6

  def initialize(e1, e2)
    @e1, @e2 = e1, e2
  end

  def similar?
    similarity >= THRESHOLD
  end

  def similarity
    0.5 * similar_actors? + 0.1 * similar_locations? + 0.4 * similar_started_ats?
  end

  private

  def similar_actors?
    result = (@e1.actors & @e2.actors).length.to_f / (@e1.actors | @e2.actors).length
    result.nan? ? 0 : result
  end

  def similar_locations?
    result = (@e1.locations & @e2.locations).length.to_f / (@e1.locations | @e2.locations).length
    result.nan? ? 0 : result
  end

  def similar_started_ats?
    r1, r2 = @e1.started_at, @e2.started_at
    return 0 if r1.nil? || r2.nil?

    days_in_range(ranges_intersection(r1, r2)).to_f / days_in_range(ranges_union(r1, r2))
  end

  def ranges_intersection(r1, r2)
    new_begin = [r1.begin, r2.begin].max
    new_end = [r1.end, r2.end].min
    exclude_end = (new_end == r1.end && r1.exclude_end?) || (new_end == r2.end && r2.exclude_end?)

    Range.new(new_begin, new_end, exclude_end)
  end

  def ranges_union(r1, r2)
    new_begin = [r1.begin, r2.begin].min
    new_end = [r1.end, r2.end].max
    exclude_end = (new_end == r1.end) ? r1.exclude_end? : r2.exclude_end?

    Range.new(new_begin, new_end, exclude_end)
  end

  def days_in_range(range)
    ((range.last - range.first) / 1.day).ceil
  end
end
