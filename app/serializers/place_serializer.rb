class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :woe_id, :name, :country, :bounding_box_coordinates
end
