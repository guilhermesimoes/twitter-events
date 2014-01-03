require "named_entity_recognizer"
require "time_parser"

class AnalyzedText
  attr_reader :text

  def initialize(text, ner = NamedEntityRecognizer, time_parser = TimeParser)
    @text = text
    @ner = ner
    @time_parser = time_parser
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
      @time_parser.get_dates(time_mention)
    end.compact
  end

  def date_ranges
    @date_ranges ||= time_mentions.map do |time_mention|
      @time_parser.get_date_ranges(time_mention)
    end.compact
  end

  def named_entities_with_tag(tag)
    named_entities.each_index.reduce([]) do |result, index|
      result << named_entities[index] if tags[index] == tag
      result
    end
  end

  private

  def time_mentions
    @time_mentions ||= named_entities_with_tag(:date)
  end
end
