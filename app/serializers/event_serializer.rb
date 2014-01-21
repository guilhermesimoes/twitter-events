class EventSerializer < ActiveModel::Serializer
  attributes :id, :locations, :actors, :description, :category, :references_count
  has_many :tweets, :through => :references

  def description
    object.to_s
  end

  def category
    Category.name(object.category)
  end
end
