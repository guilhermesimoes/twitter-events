class ChangeEventsArraysToHstores < ActiveRecord::Migration
  def up
    remove_column :events, :locations
    remove_column :events, :actors
    add_column :events, :locations, :hstore, :default => {}
    add_column :events, :actors, :hstore, :default => {}
  end

  def down
    remove_column :events, :locations
    remove_column :events, :actors
    add_column :events, :locations, :string, :array => true, :default => []
    add_column :events, :actors, :string, :array => true, :default => []
  end
end
