module Category
  UNDETERMINED = 0
  NONE = 1
  FOOTBALL_MATCH = 2
  FOOTBALL_GOAL = 3
  FOOTBALL_EVENT = 4

  def self.list
    Hash[self.constants.collect { |constant| [constant.to_s.titleize, const_get(constant)] }]
  end

  def self.name(val)
    constants.find { |constant| const_get(constant) == val }.to_s.titleize
  end
end
