require "stanford-core-nlp"

class NamedEntityRecognizer
  BACKGROUND_SYMBOL = :o

  def self.recognize(text)
    pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :ner)
    annotations = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(annotations)

    get_named_entities_and_tags(annotations.get(:tokens))
  end

  private

  ##
  # Iterates the +tokens+ and returns an array containing
  # named entities and their respective tags.
  #
  # Also joins multi-term named entities.
  #
  # For example, the following strings, after tokenization and annotation,
  # will return:
  #
  # "Alice, Bob and Eve"
  # [["Alice", :person], ["Bob", :person], ["Eve", :person]]
  #
  # "John Smith"
  # [["John Smith", :person]]

  def self.get_named_entities_and_tags(tokens)
    nes = []
    last_tag = nil
    tokens.each do |token|
      tag = token.get(:named_entity_tag).to_s.downcase.to_sym
      if tag == BACKGROUND_SYMBOL
        last_tag = nil
        next
      end

      if tag == last_tag
        nes.last[0] << " " << token.get(:original_text).to_s
      else
        last_tag = tag
        nes << [token.get(:original_text).to_s, tag]
      end
    end
    nes
  end
end
