class EventsSimilarityCalculator
  THRESHOLD = 0.55

  def initialize(e1, e2)
    @e1, @e2 = e1, e2
  end

  def similar?
    similarity >= THRESHOLD
  end

  def similarity
    0.4 * similar_actors? + 0.1 * similar_locations? + 0.5 * similar_started_ats?
  end

  private

  def similar_actors?
    result = (e1actors & e2actors).length.to_f / (e1actors | e2actors).length
    result.nan? ? 0 : result ** 1.2
  end

  def similar_locations?
    result = (e1locations & e2locations).length.to_f / (e1locations | e2locations).length
    result.nan? ? 0 : result
  end

  def similar_started_ats?
    r1, r2 = @e1.started_at, @e2.started_at
    return 0 if r1.nil? || r2.nil?

    (days_in_intersection(r1, r2).to_f / (days_in_union(r1, r2) ** 2)) ** 0.2
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

  def e1actors
    @e1actors ||= @e1.actors.keys
  end

  def e2actors
    @e2actors ||= @e2.actors.keys
  end

  def e1locations
    @e1locations ||= @e1.locations.keys
  end

  def e2locations
    @e2locations ||= @e2.locations.keys
  end
end
