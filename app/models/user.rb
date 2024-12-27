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
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
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
    user = User.find(user_id)
    create_notification_follow!(user) # フォローした後に通知を作成
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

# フォローの通知を作成
def create_notification_follow!(target_user)
  # 自分を通知対象にしないようにする
  return if self == target_user  # 自分をフォローした場合は通知しない

  # すでにフォロー通知が存在するか検索
  existing_notification = Notification.find_by(
    visitor_id: target_user.id,  # フォローしたユーザー（user2）のID
    visited_id: self.id,          # フォローされたユーザー（user1）のID
    action: 'follow'
  )

  # フォロー通知が存在しない場合のみ作成
  if existing_notification.blank?
    Notification.create(
      visitor_id: target_user.id,  # フォローしたユーザー（user2）のID
      visited_id: self.id,          # フォローされたユーザー（user1）のID
      action: 'follow',             # アクションタイプを 'follow' に設定
      checked: false                # 未確認の状態
    )
  end
end


  
  def unchecked_notifications_count
    unchecked_count = passive_notifications.where(checked: false).or(passive_notifications.where(action: 'follow', checked: false)).count
  end
  
  # コメントにお気に入りが追加されたときに通知を作成
  def create_notification_comment_favorite!(current_user, comment_id)
    notification = self.active_notifications.build(  # notifications → active_notifications に変更
      visitor_id: current_user.id,
      visited_id: self.id,
      action: 'comment_favorite',
      checked: false,
      comment_id: comment_id,
      user_id: current_user.id
    )
    notification.save!
  end

end
