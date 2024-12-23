class AddFollowerAndFollowedToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :follower_id, :integer
    add_column :notifications, :followed_id, :integer
  end
end
