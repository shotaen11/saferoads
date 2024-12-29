class RoadCondition < ApplicationRecord

  # 画像アップロード用のattachmentを設定
  attachment :image
  
  # 関連するモデルとのアソシエーション
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # バリデーションの設定
  validates :road_name, presence: true
  validates :road_status, presence: true
  validates :description, presence: true, length: { maximum: 195 }

  # 状態を示すenumを設定（公開、下書き）
  enum status: { published: 0, draft: 1 }

  # マイページで下書き投稿を非表示にするスコープ
  scope :published_only, -> { where(status: :published) }

  # ユーザーがすでにお気に入りに登録しているか確認するメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 終了時刻が未定かどうかを判断するメソッド
  def end_time_undefined?
    self.end_time_undefined == true
  end

  # ユーザーがすでにお気に入りに登録しているか確認するメソッド（重複していたため一部削除）
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # お気に入りの通知を作成するメソッド
  def create_notification_favorite!(current_user)
    # すでに「確認しました」されているかを確認する
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and road_condition_id = ? and action = ?",
      current_user.id, user_id, id, 'like'
    ])
    
    # 「確認しました」されていない場合に通知を作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        road_condition_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      
      # 自分の投稿に対する確認済み通知の場合は、通知済みに設定
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      
      # 通知が有効なら保存
      notification.save if notification.valid?
    end
  end
end
