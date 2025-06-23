Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || "/" do
    # ✅ トップページ
    root "fares#search"

    # ✅ Deviseユーザー認証
    devise_for :users

    # ✅ 運賃（fares）リソース + 検索 + CSVインポート
    resources :fares do
      collection do
        get :search                # /fares/search → fares#search
        post :import              # 地点登録CSV用
        post :import_distance_csv # 距離別運賃CSV用 ←★今回追加した処理
      end
    end

    # ✅ 管理者用ルーティング
    namespace :admin do
      resources :fares
      resources :users
    end
  end
end
