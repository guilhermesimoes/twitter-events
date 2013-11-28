class RenameRemoteIdColumns < ActiveRecord::Migration
  def change
    change_table :tweets do |t|
      t.rename :remote_id, :twitter_id
    end
    change_table :users do |t|
      t.rename :remote_id, :twitter_id
    end
    change_table :places do |t|
      t.rename :remote_id, :woe_id
    end
  end
end
