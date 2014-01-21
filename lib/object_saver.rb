require "madeleine"

class ObjectSaver
  def initialize(object, filename)
    @madeleine = SnapshotMadeleine.new(filename) { object }
    @madeleine.system
  end

  def save
    @madeleine.take_snapshot
    true
  end

  private

  def timestamped_filename
    "#{timestamp} #{@filename}"
  end

  def timestamp
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
end