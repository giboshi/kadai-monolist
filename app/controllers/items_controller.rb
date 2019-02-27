class ItemsController < ApplicationController
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
        item = Item.new(read(result))
        @items << item #itemを[]に追加
      end
    end
  end
  
  private

  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')#画像 URL 末尾に含まれる ?_ex=128x128 を削除

    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
