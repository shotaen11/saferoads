class NotificationsController < ApplicationController
  def index
    # 通知を新着順（created_at降順）で取得
    @notifications = current_user.passive_notifications.order(created_at: :desc).page(params[:page]).per(10)

    # 未確認の通知を全てチェック済みにする
    current_user.passive_notifications.where(checked: false).update_all(checked: true)

    # 未読通知をカウント（フォローアクションも含む）
    @unchecked_count = current_user.passive_notifications.where(checked: false)
                              .or(current_user.passive_notifications.where(action: 'follow', checked: false))
                              .count
  end
end
