require "named_entity_recognizer"

class AnalyzedText
  RELEVANT_ENTITIES = [:person, :organization, :location, :date]
  # :number, :ordinal, :cardinal, :quantity, :money, :percent, :o

  def initialize(text, detector, ner = NamedEntityRecognizer)
    @text = text
    @detector = detector
    @ner = ner
  end

  def has_keywords?
    !keywords.empty?
  end

  def keywords
    @keywords ||= @detector.detect(@text)
  end

  def has_relevant_entities?
    !(tags & RELEVANT_ENTITIES).empty?
  end

  def entities
    @entities ||= @ner.recognize(@text)
  end

  def named_entities
    entities[0]
  end

  def tags
    entities[1]
  end
end
