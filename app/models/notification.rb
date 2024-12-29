class Notification < ApplicationRecord
  # スコープ: 未確認通知を取得する
  # `checked: false` または `action: 'follow'` かつ `checked: false` の通知を取得
  scope :unchecked, -> { where(checked: false).or(where(action: 'follow', checked: false)) }

  # 関連: 通知が関連する `road_condition` と `comment` を optional として定義
  belongs_to :road_condition, optional: true  # RoadConditionが関連していない場合もある
  belongs_to :comment, optional: true         # Commentが関連していない場合もある

  # 関連: 通知を送ったユーザー(visitor)と受け取ったユーザー(visited)を設定
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'   # 通知を送ったユーザー
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'   # 通知を受け取ったユーザー

  # バリデーション: `action`, `visitor_id`, `visited_id` は必須　バリデーション＝チェック機能
  validates :action, presence: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  
  # `road_condition` または `comment` が通知に含まれる場合、関連IDが必須
  validates :road_condition_id, presence: true, if: :road_condition_action?  # actionが'road_condition'の場合、road_condition_idが必須
  validates :comment_id, presence: true, if: :comment_action?              # actionが'comment'の場合、comment_idが必須

  # `checked` が `true` または `false` のいずれかであることを保証
  validates :checked, inclusion: { in: [true, false] }

  # メソッド: `follow` アクションかどうかを判定
  def follow_action?
    action == 'follow'
  end

  # メソッド: `road_condition` アクションかどうかを判定
  def road_condition_action?
    action == 'road_condition'
  end

  # メソッド: `comment` アクションかどうかを判定
  def comment_action?
    action == 'comment'
  end

  # メソッド: `comment_favorite` アクションかどうかを判定
  def comment_favorite_action?
    action == 'comment_favorite'
  end
end
