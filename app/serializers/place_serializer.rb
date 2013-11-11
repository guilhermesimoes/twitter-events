class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :bounding_box_coordinates

  def id
    object.remote_id
  end
end
