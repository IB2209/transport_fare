class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
    # ログアウト後の遷移先（ログイン画面へ）
    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end