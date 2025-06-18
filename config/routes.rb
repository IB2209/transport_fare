Rails.application.routes.draw do

  scope Rails.application.config.relative_url_root || "/" do
  # ✅ ルート設定
  root "fares#search"

  # ✅ Deviseユーザー認証
  devise_for :users

  # ✅ 運賃（fares）リソース + 検索
  resources :fares do
    collection do
      get :search  # /fares/search => fares#search
    end
  end

  # ✅ 管理者用の名前空間ルーティング
  namespace :admin do
    resources :fares
    resources :users
  end

  resources :fares do
    collection { post :import }
  end  

  end
end
