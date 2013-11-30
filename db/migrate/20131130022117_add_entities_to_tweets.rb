class AddEntitiesToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :named_entities, :text, :array => true, :default => []
    add_column :tweets, :tags, :text, :array => true, :default => []
  end
end
