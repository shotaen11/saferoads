class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :road_condition, null: false, foreign_key: true
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked

      t.timestamps
    end
  end
end
