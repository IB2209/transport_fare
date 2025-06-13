require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.relative_url_root = "/coxgear/transport_fare"
  config.action_controller.relative_url_root = "/coxgear/transport_fare"
  config.assets.prefix = "/coxgear/transport_fare/assets"
  
  # ログ出力先を production.log に
  config.logger = ActiveSupport::TaggedLogging.new(
  Logger.new(Rails.root.join("log", "production.log"), 'daily') # ← 'daily'でローテーション
  )
  
  # ログレベルを明示
  config.log_level = :info

  # 本番ではコードはリロードしない（高速化）
  config.enable_reloading = false

  # 起動時に全コードを読み込む（本番ではtrueが必須）
  config.eager_load = true

  # エラー画面はユーザーに見せない（開発時は true、本番では false）
  config.consider_all_requests_local = false

  # コントローラキャッシュを有効にする（高速化）
  config.action_controller.perform_caching = true

  # 静的ファイルにキャッシュ制御ヘッダーを追加
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # ActiveStorageはローカルに保存（Amazon S3 等を使わない場合）
  config.active_storage.service = :local

  # Nginx が HTTPS 終端している想定
  config.assume_ssl = true    # ← Nginx で SSL 終端される場合に true に
  config.force_ssl = true     # ← アプリ全体を https に強制リダイレクト

  # ログに request_id を追加（デバッグしやすくする）
  config.log_tags = [ :request_id ]

  # ログ出力先（stdout）を使ってログを tagged にする
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Rails 7 のヘルスチェックAPI (`/up`) をログに出さない
  config.silence_healthcheck_path = "/up"

  # 非推奨機能の警告は非表示に
  config.active_support.report_deprecations = false

  # メモリキャッシュ（基本的なキャッシュ方式）
  config.cache_store = :memory_store

  # ActiveJob（非同期ジョブ）のキューアダプタ
  config.active_job.queue_adapter = :async

  # DeviseやURL生成で使うホスト名（重要）
  config.action_mailer.default_url_options = { host: "ibwww.com", protocol: "https" }

  # I18nのフォールバック（翻訳がなければ他言語を使う）
  config.i18n.fallbacks = true

  # マイグレーション後の schema.rb を出力しない
  config.active_record.dump_schema_after_migration = false

  # ホスト認証。Nginx経由や curl のテストなどのために明示的に許可
  config.hosts << "localhost"
  config.hosts << "ibwww.com"
  
end
