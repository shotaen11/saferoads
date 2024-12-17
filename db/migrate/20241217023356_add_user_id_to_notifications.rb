class AddUserIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :user_id, :integer
  end
end
