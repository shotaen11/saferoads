class AddUserIdToRoadConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :road_conditions, :user_id, :integer
  end
end
