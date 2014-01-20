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
    @named_entities ||= entities.keys
  end

  def tags
    @tags ||= entities.values
  end

  def dates
    @dates ||= time_mentions
  end

  def date_ranges
    @date_ranges ||= time_mentions(:range => true)
  end

  def named_entities_by_tag(tag)
    return @named_entities_by_tag[tag] unless @named_entities_by_tag[tag].nil?
    @named_entities_by_tag[tag] = entities.map { |k, v| v == tag ? k : nil }.compact
  end

  private

  def time_mentions(opts = {})
    time_mentions = named_entities_by_tag(:date).map do |time_mention|
      Chronic.parse(time_mention, :now => @time_context, :guess => !opts[:range])
    end
    time_mentions.compact!
    time_mentions.uniq!
    time_mentions
  end
end
