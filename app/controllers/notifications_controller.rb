class NotificationsController < ApplicationController
    before_action :authenticate_user!  # ユーザーがログインしているか確認
  
    # ユーザーに関連する未読通知を表示
    def index
      # 現在のユーザーの未読通知を取得
      @notifications = current_user.passive_notifications.unchecked
      
      @notifications.each do |notification|
        notification.update(checked: true)
      end

    end
  end
  