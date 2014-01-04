require "named_entity_recognizer"

class AnalyzedText
  attr_reader :text

  def initialize(text, time_context = Time.now, ner = NamedEntityRecognizer)
    @text = text
    @time_context = time_context
    @ner = ner
    @named_entities_by_tag = {}
  end

  def entities
    @entities ||= @ner.recognize(@text)
  end

  def named_entities
    @named_entities ||= entities[0]
  end

  def tags
    @tags ||= entities[1]
  end

  def dates
    @dates ||= time_mentions.map do |time_mention|
      Chronic.parse(time_mention, :now => @time_context)
    end.compact
  end

  def date_ranges
    @date_ranges ||= time_mentions.map do |time_mention|
      Chronic.parse(time_mention, :guess => false, :now => @time_context)
    end.compact
  end

  def named_entities_by_tag(tag)
    return @named_entities_by_tag[tag] unless @named_entities_by_tag[tag].nil?

    @named_entities_by_tag[tag] = named_entities.each_index.reduce([]) do |result, index|
      result << named_entities[index] if tags[index] == tag
      result
    end
  end

  private

  def time_mentions
    named_entities_by_tag(:date)
  end
end
