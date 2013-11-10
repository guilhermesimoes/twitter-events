class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :remote_id
      t.string :name
      t.string :country
      t.text :bounding_box_coordinates, :array => true, :default => []
    end
  end
end
