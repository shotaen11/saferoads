class RoadCondition < ApplicationRecord

    attachment :image
    belongs_to :user
end
