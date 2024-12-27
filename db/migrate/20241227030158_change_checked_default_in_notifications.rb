class ChangeCheckedDefaultInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notifications, :checked, false
    change_column_null :notifications, :checked, false, false 
  end
end
