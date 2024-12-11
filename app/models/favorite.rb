class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :road_condition
  
    validates :user_id, uniqueness: { scope: :road_condition_id, message: "はすでに確認しています" }
  end
  