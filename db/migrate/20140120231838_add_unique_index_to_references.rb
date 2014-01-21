class AddUniqueIndexToReferences < ActiveRecord::Migration
  def change
    add_index :references, [:tweet_id, :event_id], :unique => true
  end
end
