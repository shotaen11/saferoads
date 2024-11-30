class RoadConditionsController < ApplicationController
  # 新しい道路状況を作成するためのフォームを表示
  def new
    @road_condition = RoadCondition.new
  end

  # 新しい道路状況をデータベースに保存
  def create
    @road_condition = RoadCondition.new(road_conditions_params)
    @road_condition.user_id = current_user.id
    handle_end_time_undefined #未定のチェック対応
    if @road_condition.save
      redirect_to road_condition_path(@road_condition)
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  # 道路状況の一覧を表示
  def index
    # ページネーションを設定して最新順に並べる
    @road_conditions = RoadCondition.published.page(params[:page]).reverse_order
   # 検索条件を動的に追加
    if params[:search].present?
      @road_conditions = @road_conditions.where(
       'road_name LIKE :search OR road_status LIKE :search OR description LIKE :search',
       search: "%#{params[:search]}%"
      )
    end
  end

  # 特定の道路状況の詳細を表示
  def show
    @road_condition = RoadCondition.find(params[:id])
    @comment = Comment.new # コメントフォームで使用
    @comments = @road_condition.comments.page(params[:page]).per(7).reverse_order
  end 

  # 道路状況の編集フォームを表示
  def edit
    @road_condition = RoadCondition.find(params[:id]) # 編集対象のデータを取得
  end
  

  # 編集された道路状況を更新
  def update
    @road_condition = RoadCondition.find(params[:id]) # 編集対象のデータを取得

    # 終了時刻未定チェックがオンの場合、end_timeをnilに設定
    if params[:road_condition][:end_time_undefined] == "1"
      @road_condition.end_time = nil
    end

    if @road_condition.update(road_conditions_params)
      redirect_to road_condition_path(@road_condition) # 更新成功時のリダイレクト
    else
      render :edit, status: :unprocessable_entity # 更新失敗時にエラーを再描画
    end
  end

  # 道路状況を削除
  def destroy
    road_condition = RoadCondition.find(params[:id]) # 削除対象を取得
    road_condition.destroy # 削除処理
    redirect_to road_conditions_path # 一覧ページにリダイレクト
  end

  # 下書き
  def confirm
    @road_conditions = current_user.road_conditions.draft.page(params[:page]).reverse_order
  end

  private

  def handle_end_time_undefined
    # end_timeが未設定の場合にnilを設定
    @road_condition.end_time ||= nil
  end

  # Strong Parameters: 道路状況に許可するパラメータを制限
  def road_conditions_params
    params.require(:road_condition).permit(:user_id, :road_name, :road_status, :description, :image, :status, :start_time, :end_time, :end_time_undefined)
  end
 end