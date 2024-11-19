class RoadCondition < ApplicationRecord

    attachment :image
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy

#   ユーザーidがFavoritesテーブルに存在するか
    def favorited_by?(user)
      favorites.where(user_id: user.id).exists?
    end
end
