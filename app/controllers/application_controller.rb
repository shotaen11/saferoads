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

  def create_notification(road_condition:, visiter:, visited:, action:, comment: nil)
    return if visiter == visited # 自分に通知しない
  
    if action == 'follow'
      Notification.create!(
        road_condition: road_condition,
        visiter: visiter,
        visited: visited,
        action: 'follow', # フォローアクション
        follower_id: visiter.id, # フォロワーID
        followed_id: visited.id, # フォロワー先のID
        checked: false
      )
    else
      Notification.create!(
        road_condition: road_condition,
        visiter: visiter,
        visited: visited,
        action: action,
        comment: comment,
        checked: false
      )
    end
  end
  
end
