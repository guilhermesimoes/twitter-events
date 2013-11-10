class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :remote_id
      t.string :name
      t.string :screen_name
      t.string :description
      t.string :website_url
      t.string :image_url
      t.string :location
      t.integer :followers_count
      t.datetime :created_at
    end
  end
end
