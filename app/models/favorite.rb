class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :road_condition
end