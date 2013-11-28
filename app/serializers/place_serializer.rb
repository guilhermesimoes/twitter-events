class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :bounding_box_coordinates

  def id
    object.woe_id
  end
end
