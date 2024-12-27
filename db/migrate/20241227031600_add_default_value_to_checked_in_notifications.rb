class AddDefaultValueToCheckedInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notifications, :checked, false
  end
end
