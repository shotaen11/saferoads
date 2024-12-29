class User < ApplicationRecord
  # Deviseのモジュールを追加（デフォルトで以下のモジュールが含まれています）
  # 他にも :confirmable, :lockable, :timeoutable, :trackable, :omniauthable があります
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # ユーザー名のバリデーション（名前が空でないことを確認）
  validates :name, presence: true

  # ユーザーに関連するモデルとのアソシエーション設定
  has_many :road_conditions, dependent: :destroy # ユーザーが作成した道路状況
  has_many :comments, dependent: :destroy # ユーザーが作成したコメント
  has_many :favorites, dependent: :destroy # ユーザーのお気に入り
  has_many :comment_favorites, dependent: :destroy # ユーザーのお気に入りコメント

  # 通知機能: 自分からの通知（active_notifications）、相手からの通知（passive_notifications）
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy # 自分から送信した通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy # 相手から受信した通知

  # フォロー機能の関連付け
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォローしている人
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォローされている人
  has_many :following_user, through: :follower, source: :followed # フォローしているユーザー
  has_many :follower_user, through: :followed, source: :follower # フォロワーのユーザー

  # プロフィール画像のアップロード
  attachment :profile_image

  # フォローするメソッド（指定されたユーザーIDをフォロー）
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # フォローを解除するメソッド（指定されたユーザーIDのフォローを解除）
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # 指定したユーザーをフォローしているか確認するメソッド
  def following?(user)
    following_user.include?(user)
  end

  # お気に入り登録された投稿を取得する関連
  has_many :favorited_road_conditions, through: :favorites, source: :road_condition

  # お気に入り登録するメソッド（指定された投稿をお気に入りに追加）
  def favorite(road_condition)
    favorited_road_conditions << road_condition unless favorited_road_conditions.include?(road_condition)
  end

  # お気に入り解除するメソッド（指定された投稿をお気に入りから削除）
  def unfavorite(road_condition)
    favorited_road_conditions.delete(road_condition)
  end

  # 投稿がお気に入りされているか確認するメソッド
  def favorited_by?(road_condition)
    favorited_road_conditions.include?(road_condition)
  end

  # コメントの「確認しました」機能を実装（コメントをお気に入りに追加）
  def favorite_comment(comment)
    CommentFavorite.create(user: self, comment: comment)
  end

  # コメントの「確認しました」を解除する機能
  def unfavorite_comment(comment)
    CommentFavorite.find_by(user: self, comment: comment)&.destroy
  end

  # コメントが「確認しました」されているか確認するメソッド
  def comment_favorited?(comment)
    CommentFavorite.exists?(user: self, comment: comment)
  end

  # フォローの通知を作成するメソッド
  def create_notification_follow!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ?', current_user.id, id, 'follow'])
    return if temp.present? # 既に通知が存在する場合は作成しない

    notification = current_user.active_notifications.new(
      visited_id: id,
      action: 'follow'
    )
    notification.save if notification.valid?
  end

  # 未確認の通知数をカウントするメソッド
  def unchecked_notifications_count
    unchecked_count = passive_notifications.where(checked: false).or(passive_notifications.where(action: 'follow', checked: false)).count
  end
end
