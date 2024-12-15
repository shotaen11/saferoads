class RoadCondition < ApplicationRecord

    attachment :image
    belongs_to :user
    belongs_to :category
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :notifications, dependent: :destroy

    validates :road_name, presence: true
    validates :road_status, presence: true
    validates :description, presence: true, length: { maximum: 195 } 

    # enum カラム名：{名前:番号}
    enum status: { published: 0, draft: 1 }
    # mypageで下書き投稿を非表示にするため、スコープの定義
    scope :published_only, -> { where(status: :published) }

    #   ユーザーidがFavoritesテーブルに存在するか
    def favorited_by?(user)
      favorites.where(user_id: user.id).exists?
    end

      # 終了時刻が未定かどうかを判断
    def end_time_undefined?
      self.end_time_undefined == true
    end

    def favorited_by?(user)
      favorites.exists?(user_id: user.id)
    end

    def create_notification_like!(current_user)
      #すでに「確認しました」をされているか検索
      temp = Notification.where(["visiter_id = ? and visited_id = ? and road_condition_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
      # 確認しましたされていない場合のみ、通知レコードを作成
      if temp.blank?
        notification = current_user.active_notifications.new(
          road_condition_id: id,
          visited_id: user_id,
          action: 'like'
        )
        # 自分の投稿に対する確認しましたの場合は、通知済みとする
        if notification.visiter_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
      end
    end 
end
