class RelationshipsController < ApplicationController
  # フォロー処理を行うアクション
  def create
    @user = User.find(params[:user_id])          # 対象となるユーザーを取得
    current_user.follow(@user.id)                # 現在のログインユーザーが対象ユーザーをフォロー
    @user.create_notification_follow!(current_user)  # フォロー後に通知を作成

    # フォロー後、元のページにリダイレクト（リファラを参照）
    redirect_to request.referer
  end
  
  # フォロー解除処理を行うアクション
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])     # 現在のログインユーザーが対象ユーザーのフォローを解除

    # フォロー解除後、元のページにリダイレクト（リファラを参照）
    redirect_to request.referer
  end
end
