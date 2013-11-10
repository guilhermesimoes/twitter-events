class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :remote_id
      t.string :text
      t.datetime :created_at
      t.text :coordinates, :array => true, :default => []

      t.integer :user_id, :null => false
      t.integer :place_id, :null => false
    end
  end
end
