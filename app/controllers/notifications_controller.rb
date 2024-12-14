class NotificationsController < ApplicationController
  before_action :authenticate_user!  # ユーザーがログインしているか確認

  # ユーザーに関連する未読通知を表示
  def index
    # 現在のユーザーの未読通知を取得
    @notifications = current_user.passive_notifications.unchecked
  end

  # 通知の詳細ページ（クリックされたときに通知を確認済みにする）
  def update
    # 通知をクリックして、その通知だけを確認済みにする
    @notification = Notification.find(params[:id])
    @notification.update(checked: true)
    
    # 通知先のページにリダイレクト（例えば、road_conditionの詳細ページなど）
    redirect_to road_condition_path(@notification.road_condition)
  end
end
