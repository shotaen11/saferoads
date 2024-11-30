class RoadCondition < ApplicationRecord

    attachment :image
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy

    validates :road_name, presence: true
    validates :road_status, presence: true
    validates :description, presence: true, length: { maximum: 195 }
    validates :image, presence: true  

    # enum カラム名：{名前:番号}
    enum status: { published: 0, draft: 1 }

    #   ユーザーidがFavoritesテーブルに存在するか
    def favorited_by?(user)
      favorites.where(user_id: user.id).exists?
    end

      # 終了時刻が未定かどうかを判断
    def end_time_undefined?
      self.end_time_undefined == true
    end
end
