Devise.setup do |config|
  # 🔑 ログインに使うキーを `user_id` に変更（必須！）
  config.authentication_keys = [:user_id]

  # 📦 セッション保存を最小限に（デフォルトのままでOK）
  config.skip_session_storage = [:http_auth]

  # ✅ CSRF対策トークンの処理（デフォルト）
  config.clean_up_csrf_token_on_authentication = true

  # 📧 メール送信者（任意であなたの運営者メールに変更）
  config.mailer_sender = 'noreply@ibwww.com'

  # 🏁 エラーステータスやリダイレクト（Turboを使っていれば必要）
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # 🔒 パスワード設定
  config.password_length = 6..128
  config.reset_password_within = 6.hours

  # 🚪ログアウト方法
  config.sign_out_via = :delete

  # ✅ ActiveRecord使用
  require 'devise/orm/active_record'

  # config/initializers/devise.rb
  require Rails.root.join("lib/custom_failure_app")

    Devise.setup do |config|
    # 既存の設定の後に追記
      config.warden do |manager|
        manager.failure_app = CustomFailureApp
      end
    end

end
