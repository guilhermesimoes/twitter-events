require "named_entity_recognizer"

class AnalyzedText
  attr_reader :text

  def initialize(text, ner = NamedEntityRecognizer)
    @text = text
    @ner = ner
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
