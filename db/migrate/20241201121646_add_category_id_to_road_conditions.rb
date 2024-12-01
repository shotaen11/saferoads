class AddCategoryIdToRoadConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :road_conditions, :category_id, :integer
  end
end
