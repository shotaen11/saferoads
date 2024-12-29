class CategoriesController < ApplicationController
  # アクションごとに、指定したカテゴリーを設定（`show`, `edit`, `update`, `destroy`）
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  # カテゴリーの一覧を取得
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  # 特定のカテゴリーの詳細を表示
  def show
  end

  # GET /categories/new
  # 新しいカテゴリーを作成するためのフォームを表示
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  # 既存のカテゴリーを編集するためのフォームを表示
  def edit
  end

  # POST /categories or /categories.json
  # 新しいカテゴリーを作成
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        # カテゴリーが正常に保存された場合、詳細ページにリダイレクト
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        # カテゴリーが保存できなかった場合、`new`ページを再表示
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  # 既存のカテゴリーを更新
  def update
    respond_to do |format|
      if @category.update(category_params)
        # カテゴリーが正常に更新された場合、詳細ページにリダイレクト
        format.html { redirect_to @category, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        # カテゴリーが更新できなかった場合、`edit`ページを再表示
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  # 特定のカテゴリーを削除
  def destroy
    @category.destroy!

    respond_to do |format|
      # カテゴリーが削除された場合、カテゴリー一覧ページにリダイレクト
      format.html { redirect_to categories_path, status: :see_other, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # 共通のセットアップや制約をアクションごとに設定
    def set_category
      @category = Category.find(params[:id])
    end

    # 許可するパラメータを設定
    def category_params
      params.require(:category).permit(:name)
    end
end
