class EventsCreator
  def initialize(tweet, analyzed_text)
    @tweet = tweet
    @analyzed_text = analyzed_text
  end

  def execute
    date_ranges = @analyzed_text.date_ranges
    events = []
    if date_ranges.empty?
      # assume tweet is referring to an event that will happen this week
      # [Time.now..(Time.now + 1.week)]
      new_event = initialize_event(nil)
      new_event.save!
      events << new_event
    else
      date_ranges.each do |date_range|
        events << create_or_merge_event(date_range)
      end
    end
    events.compact
  end

  private

  def create_or_merge_event(date_range)
    new_event = initialize_event(date_range)
    events = similar_events(new_event)
    if events.empty?
      new_event.save!
      nil
    else
      merge_with_similar_events(new_event, events)
      events.select { |event| event.references_count >= 0 }
    end
  end

  def initialize_event(started_at)
    Event.new do |event|
      event.started_at = started_at
      event.locations = initialize_hstore @analyzed_text.named_entities_by_tag(:location)
      event.actors = initialize_hstore @analyzed_text.named_entities_by_tag(:organization)
      event.category = Category::MATCH
      event.references.new(:tweet => @tweet)
    end
  end

  def initialize_hstore(array)
    hash = {}
    array.each { |key| hash[key] = 1 }
    hash
  end

  def similar_events(new_event)
    events = Event.where(:category => Category::MATCH).where_started_at_overlaps(new_event.started_at)
    events.select { |event| EventsSimilarityCalculator.new(new_event, event).similar? }
  end

  def merge_with_similar_events(new_event, events)
    events.each do |event|
      begin
        event.references.new(:tweet => @tweet)
        event.locations.default = 0
        new_event.locations.keys.each { |key| event.locations[key] = event.locations[key].to_i + 1 }
        event.locations_will_change!
        event.actors.default = 0
        new_event.actors.keys.each { |key| event.actors[key] = event.actors[key].to_i + 1 }
        event.actors_will_change!
        event.save!
      rescue ActiveRecord::RecordNotUnique
        # Let's make sure we don't add a tweet more than once as a reference to the same event
      end
    end
  end
end
