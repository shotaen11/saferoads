class FavoritesController < ApplicationController
  # ユーザーがログインしていない場合はアクセスできないようにする
  before_action :authenticate_user!

  # いいね（お気に入り）を追加するアクション
  def create
    @road_condition = RoadCondition.find(params[:road_condition_id]) # 対象となるRoadConditionを取得
    current_user.favorite(@road_condition)                           # 現在のユーザーがRoadConditionにいいねを追加

    # いいねを追加した際に通知を作成
    @road_condition.create_notification_favorite!(current_user)

    # Turbo Streamを使用して非同期でビューを更新
    respond_to do |format|
      format.turbo_stream
    end
  end

  # いいね（お気に入り）を削除するアクション
  def destroy
    @road_condition = RoadCondition.find(params[:road_condition_id])  # 対象となるRoadConditionを取得
    current_user.unfavorite(@road_condition)                          # 現在のユーザーがRoadConditionからいいねを外す

    # いいねを外した後のFavoritesのカウントをログに出力
    Rails.logger.debug "Favorites count after destroy: #{@road_condition.favorites.count}"

    # Turbo Streamを使用して非同期でビューを更新
    respond_to do |format|
      format.turbo_stream
    end
  end
end
