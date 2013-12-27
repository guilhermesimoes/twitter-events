require "stanford-core-nlp"

class NamedEntityRecognizer
  BACKGROUND_SYMBOL = :o

  def self.recognize(text)
    pipeline
    annotations = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(annotations)

    get_named_entities_and_tags(annotations.get(:tokens))
  end

  private

  def self.pipeline
    @pipeline ||= StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :ner)
  end

  ##
  # Iterates the +tokens+ and returns an array of arrays.
  # The first array contains named entities and the second
  # contains their respective tags.
  #
  # Also joins multi-term named entities.
  #
  # For example, the following strings, after tokenization and annotation:
  #
  # 1. "Alice, Bob and Eve"
  #
  # 2. "John Smith"
  #
  # Will return:
  #
  # 1. [["Alice", "Bob", "Eve"], [:person, :person, :person]]
  #
  # 2. [["John Smith"], [:person]]

  def self.get_named_entities_and_tags(tokens)
    named_entities = []
    tags = []
    last_tag = nil
    tokens.each do |token|
      tag = token.get(:named_entity_tag).to_s.downcase.to_sym
      if tag == BACKGROUND_SYMBOL
        last_tag = nil
        next
      end

      if tag == last_tag
        named_entities.last << " " << token.get(:original_text).to_s
      else
        last_tag = tag
        named_entities << token.get(:original_text).to_s
        tags << tag
      end
    end
    [named_entities, tags]
  end
end
