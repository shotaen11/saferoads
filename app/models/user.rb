class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  has_many :road_conditions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comment_favorites, dependent: :destroy
  
  #通知機能　active_notifications：自分からの通知　passive_notifications：相手からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visiter_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # フォロー機能の関連付け
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  # プロフィール画像
  attachment :profile_image

  # フォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしている場合、trueを返す
  def following?(user)
    following_user.include?(user)
  end

  # お気に入り登録された投稿を取得
  has_many :favorited_road_conditions, through: :favorites, source: :road_condition

  # お気に入り登録
  def favorite(road_condition)
    favorited_road_conditions << road_condition unless favorited_road_conditions.include?(road_condition)
  end

  # お気に入り解除
  def unfavorite(road_condition)
    favorited_road_conditions.delete(road_condition)
  end

  # お気に入り登録されているか確認
  def favorited_by?(road_condition)
    favorited_road_conditions.include?(road_condition)
  end

  # コメントの「確認しました」関連メソッド
  def favorite_comment(comment)
    CommentFavorite.create(user: self, comment: comment)
  end

  def unfavorite_comment(comment)
    CommentFavorite.find_by(user: self, comment: comment)&.destroy
  end

  def comment_favorited?(comment)
    CommentFavorite.exists?(user: self, comment: comment)
  end

  #フォローの通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  #コメント確認しましたの通知
  def create_notification_comment_favorite!(current_user, comment_id)
    comment = Comment.find_by(id: comment_id)
    return if comment.nil?
  
    road_condition_id = comment.road_condition_id # コメントに関連する road_condition_id を取得
  
    # 既存通知の確認
    temp = Notification.where(
      visiter_id: current_user.id,
      visited_id: id,
      comment_id: comment_id,
      road_condition_id: road_condition_id,
      action: 'comment_favorite'
    )
    if temp.blank?
      # 通知の作成
      notification = current_user.active_notifications.new(
        visited_id: id,
        road_condition_id: road_condition_id, # ここで road_condition_id を渡す
        comment_id: comment_id,
        action: 'comment_favorite',
        checked: false
      )
      notification.save if notification.valid?
    end
  end
  
end
