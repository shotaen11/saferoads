class AddStatusToRoadConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :road_conditions, :status, :integer, default: 0, null: false
  end
end
