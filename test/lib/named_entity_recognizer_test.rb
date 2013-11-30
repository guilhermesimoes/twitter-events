require "test_helper"
require "named_entity_recognizer"

describe NamedEntityRecognizer do
  let(:ner) { NamedEntityRecognizer }

  describe "::recognize" do
    it "must recognize people" do
      ner.recognize("Merkel is a politician.").must_equal [["Merkel"], [:person]]
    end

    it "must recognize multi-term named entities" do
      ner.recognize("Her full name is Angela Merkel.").must_equal [["Angela Merkel"], [:person]]
    end

    it "must recognize dates" do
      ner.recognize("She was born on the 17th of July, 1954.")
        .must_equal [["the 17th of July , 1954"], [:date]]
    end

    it "must recognize organizations" do
      ner.recognize("She's the leader of the Christian Democratic Union.")
        .must_equal [["Christian Democratic Union"], [:organization]]
    end

    it "must recognize locations" do
      ner.recognize("She is also the Chancellor of Germany").must_equal [["Germany"], [:location]]
    end

    it "must not mix named entities" do
      ner.recognize("Merkel's best friends are Hollande and Cameron.")
        .must_equal [["Merkel", "Hollande", "Cameron"], [:person, :person, :person]]
    end
  end
end
