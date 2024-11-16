class CreateRoadConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :road_conditions do |t|
      t.string :road_name
      t.string :road_status
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.timestamps
    end
  end
end
