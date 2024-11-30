class AddEndTimeUndefinedToRoadConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :road_conditions, :end_time_undefined, :boolean
  end
end
