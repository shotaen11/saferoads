class RelationshipsController < ApplicationController
  # フォロー処理を行うアクション
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    # 通知を作成
    @user.create_notification_follow!(current_user)
    redirect_to request.referer
  end
  
  # フォロー解除処理を行うアクション
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
end
