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

    days_in_intersection(r1, r2).to_f / days_in_union(r1, r2)
  end

  def days_in_intersection(r1, r2)
    intersection_begin = [r1.begin, r2.begin].max
    intersection_end = [r1.end, r2.end].min
    days_between_dates(intersection_begin, intersection_end)
  end

  def days_in_union(r1, r2)
    union_begin = [r1.begin, r2.begin].min
    union_end = [r1.end, r2.end].max
    days_between_dates(union_begin, union_end)
  end

  def days_between_dates(date1, date2)
    ((date2 - date1) / 1.day).ceil
  end
end
