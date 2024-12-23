class ChangeRoadConditionIdInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notifications, :road_condition_id, true
  end
end
