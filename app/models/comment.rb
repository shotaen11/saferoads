class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :road_condition
    has_many :comment_favorites, dependent: :destroy

    validates :comment, presence: true, length: { maximum: 35 }

    #   ユーザーidがCommentFavoritesテーブルに存在するか
    def favorited_by?(user)
        comment_favorites.where(user_id: user.id).exists?
    end
end
