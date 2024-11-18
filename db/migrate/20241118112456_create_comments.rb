class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :road_condition_id

      t.timestamps
    end
  end
end
