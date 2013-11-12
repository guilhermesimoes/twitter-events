class PortugalClient < Twitter::Streaming::Client
  OPTIONS = {
    # Coordinates of Portugal's bounding box
    :locations => %w(-9.580936 36.949892 -6.340828 41.983994).join(","),
    :language => "pt"
  }

  def filter(options={}, &block)
    options = OPTIONS.merge(options)
    super
  end
end
