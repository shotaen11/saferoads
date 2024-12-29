class RoadConditionsController < ApplicationController
  # 新しい報告を作成するためのフォームを表示
  def new
    @road_condition = RoadCondition.new
  end

  # 新しい道路状況報告をデータベースに保存
  def create
    @road_condition = RoadCondition.new(road_conditions_params)
    @road_condition.user_id = current_user.id  # 現在のログインユーザーIDを設定
    handle_end_time_undefined  # 未定の終了時間チェック処理
    if @road_condition.save
      # 保存成功後、詳細ページにリダイレクト
      redirect_to road_condition_path(@road_condition)
    else
      # 保存失敗時に新規作成フォームを再表示
      render :new, status: :unprocessable_entity
    end
  end
  
  # 報告の一覧を表示
  def index
    # 公開された報告をページネーションと共に取得
    @road_conditions = RoadCondition.published.page(params[:page]).reverse_order
    
    # 検索条件を動的に追加（検索キーワードがあれば）
    if params[:search].present?
      @road_conditions = @road_conditions.where(
        'road_name LIKE :search OR road_status LIKE :search OR description LIKE :search OR category_id LIKE :search',
        search: "%#{params[:search]}%"
      )
    else
      flash.now[:alert] = 'キーワードを入力してください。'  # 検索キーワードが入力されていない場合の警告
    end
  end
  
  # 報告の詳細を表示
  def show
    @road_condition = RoadCondition.find(params[:id])  # 報告IDを取得
    @comment = Comment.new  # コメント作成フォームを初期化
    @comments = @road_condition.comments.page(params[:page]).per(7).reverse_order  # コメントの一覧をページネーション付きで表示
  end 

  # 報告の編集フォームを表示
  def edit
    @road_condition = RoadCondition.find(params[:id])  # 編集対象の報告を取得
  end
  
  # 編集された報告を更新
  def update
    @road_condition = RoadCondition.find(params[:id])
  
    # 終了時刻が未定の場合、終了時刻をnilに設定
    if params[:road_condition].present? && params[:road_condition][:end_time_undefined] == "1"
      @road_condition.end_time = nil
    end
  
    if @road_condition.update(road_conditions_params)
      # 更新成功時に詳細ページにリダイレクト
      redirect_to road_condition_path(@road_condition)
    else
      # 更新失敗時に編集フォームを再表示
      render :edit, status: :unprocessable_entity
    end
  end
  
  # 報告を削除
  def destroy
    road_condition = RoadCondition.find(params[:id])  # 削除対象の報告を取得
    road_condition.destroy  # 削除処理
    # 一覧ページにリダイレクト
    redirect_to road_conditions_path
  end

  # 下書きページを表示
  def confirm
    @road_conditions = current_user.road_conditions.draft.page(params[:page]).reverse_order  # 現在のユーザーの下書き状態の道路状況を取得

    # 検索条件を動的に追加（検索キーワードがあれば）
    if params[:search].present?
      @road_conditions = @road_conditions.where(
        'road_name LIKE :search OR road_status LIKE :search OR description LIKE :search OR category_id LIKE :search',
        search: "%#{params[:search]}%"
      )
    else
      flash.now[:alert] = 'キーワードを入力してください。'  # 検索キーワードが入力されていない場合の警告
    end 
  end

  private

  # 未定の終了時間をnilに設定するヘルパーメソッド
  def handle_end_time_undefined
    @road_condition.end_time ||= nil  # 終了時刻が未設定の場合、nilを設定
  end

  # Strong Parameters: 許可するパラメータを制限
  def road_conditions_params
    params.require(:road_condition).permit(:user_id, :road_name, :road_status, :description, :image, :status, :start_time, :end_time, :end_time_undefined, :category_id)
  end
end
