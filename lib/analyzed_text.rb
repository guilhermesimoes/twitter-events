require "named_entity_recognizer"

class AnalyzedText
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

  def has_entities?
    !entities[1].empty?
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
