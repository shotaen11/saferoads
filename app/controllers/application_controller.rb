class ApplicationController < ActionController::Base
  # ログインが必要なアクションを設定（`top`アクションのみログイン不要）
  before_action :authenticate_user!, except: [:top]
  
  # Deviseコントローラーが呼び出されたときに、パラメータを許可する設定を追加
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Deviseのパラメータ許可を設定
  # サインアップ時に`name`パラメータを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # サインイン後のリダイレクト先を設定
  # ログイン成功後は`road_conditions_path`へリダイレクト
  def after_sign_in_path_for(resource)
    road_conditions_path
  end

  # 通知を作成するメソッド
  # フォローアクションなどに応じて通知を生成
  def create_notification(road_condition:, visiter:, visited:, action:, comment: nil)
    # 自分に通知しない
    return if visiter == visited 

    # フォローアクションの場合
    if action == 'follow'
      Notification.create!(
        road_condition: road_condition, # 通知対象の道路状態
        visiter: visiter,               # 通知を送るユーザー（訪問者）
        visited: visited,               # 通知を受け取るユーザー（訪問先）
        action: 'follow',               # アクションタイプ（フォロー）
        follower_id: visiter.id,        # フォロワーID
        followed_id: visited.id,        # フォローされるID
        checked: false                  # 通知が未確認
      )
    else
      # フォロー以外のアクションの場合
      Notification.create!(
        road_condition: road_condition, # 通知対象の道路状態
        visiter: visiter,               # 通知を送るユーザー（訪問者）
        visited: visited,               # 通知を受け取るユーザー（訪問先）
        action: action,                 # アクションタイプ（例: コメント）
        comment: comment,               # コメント内容（任意）
        checked: false                  # 通知が未確認
      )
    end
  end
  
end
