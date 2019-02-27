class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
  end
  
  def new
    @items = []

    @keyword = params[:keyword] #フォームから送信される検索ワードを取得
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1, #画像があるもののみに絞り込み
        hits: 20,
      })

      results.each do |result|
        # 扱い易いように Item としてインスタンスを作成する（保存はしない）
        item = Item.find_or_initialize_by(read(result))
        @items << item #itemを[]に追加
      end
    end
  end
  
  private

  
end
