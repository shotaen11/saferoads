class CommentFavorite < ApplicationRecord
    belongs_to :user
    belongs_to :comment

    validates :user_id, uniqueness: { scope: :comment_id, message: "はすでに確認しています" }
end
