require "ankusa"
require "ankusa/memory_storage"

class BayesClassifier
  def initialize
    storage = Ankusa::MemoryStorage.new
    @classifier = Ankusa::NaiveBayesClassifier.new(storage)
  end

  def classify(text)
    @classifier.classify(text)
  end

  def train(klass, text)
    @classifier.train(klass, text)
  end
end
