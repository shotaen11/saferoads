class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :road_condition
    has_many :comment_favorites, dependent: :destroy
    has_many :notifications, dependent: :destroy

    validates :comment, presence: true, length: { maximum: 150 }

    #   ユーザーidがCommentFavoritesテーブルに存在するか
    def favorited_by?(user)
        comment_favorites.where(user_id: user.id).exists?
    end

    def create_notification_comment!(current_user, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(road_condition_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      # 自分がコメントしている場合には通知を送らないようにする
      if temp_ids.blank? && current_user.id != user_id
        save_notification_comment!(current_user, comment_id, user_id)
      end
    end
    
    
    def save_notification_comment!(current_user, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_user.active_notifications.new(
        road_condition_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
      
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
    
      # 通知を保存
      notification.save if notification.valid?
    end
    
    
end
