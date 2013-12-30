class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.tstzrange :started_at
      t.tstzrange :finished_at
      t.string :locations, :array => true, :default => []
      t.string :actors, :array => true, :default => []
      t.string :description
      t.string :category
      t.integer :references_count, :default => 0
    end

    create_table :references do |t|
      t.integer :tweet_id, :null => false
      t.integer :event_id, :null => false
      t.integer :certainty
    end

    add_index :events, :started_at, :using => "gist"
    add_index :events, :finished_at, :using => "gist"
    add_index :references, :tweet_id
    add_index :references, :event_id
  end
end
