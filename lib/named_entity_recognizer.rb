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
  # Iterates the +tokens+ and returns a hash of named entities as keys
  # and their respective tags as values.
  #
  # Multi-term named entities are joined.
  #
  # Duplicate named entities are removed.
  #
  # For example, the following strings, after tokenization and annotation:
  #
  # 1. "Alice, Bob and Eve"
  #
  # 2. "John Smith"
  #
  # Will return:
  #
  # 1. { "Alice" => :person, "Bob" => :person, "Eve" => :person }
  #
  # 2. { "John Smith" => :person }

  def self.get_named_entities_and_tags(tokens)
    nets = []
    last_tag = nil
    tokens.each do |token|
      tag = token.get(:named_entity_tag).to_s.downcase.to_sym
      if tag == BACKGROUND_SYMBOL
        last_tag = nil
        next
      end

      if tag == last_tag
        nets.last[0] << " " << token.get(:original_text).to_s
      else
        last_tag = tag
        nets << [token.get(:original_text).to_s, tag]
      end
    end
    nets.to_h
  end
end
