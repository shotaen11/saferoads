class AddImageIdToRoadConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :road_conditions, :image_id, :string
  end
end
