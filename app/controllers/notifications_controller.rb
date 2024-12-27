class NotificationsController < ApplicationController
  def index
    # 通知を新着順で取得し、ページネーションを適用
    @notifications = current_user.passive_notifications.order(created_at: :desc).page(params[:page]).per(10)

    # 未読の通知をすべて既読に更新
    current_user.passive_notifications.where(checked: false).update_all(checked: true)
  end
end
