class EnglandClient < Twitter::Streaming::Client
  OPTIONS = {
    # Coordinates of England's bounding box
    :locations => %w(-5.914078 49.95122 2.325668 55.751849).join(","),
    :language => "en"
  }

  def filter(options={}, &block)
    options = OPTIONS.merge(options)
    super
  end
end
