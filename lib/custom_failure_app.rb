# lib/custom_failure_app.rb
class CustomFailureApp < Devise::FailureApp
  def redirect_url
    # 正しいリダイレクト先を明示的に指定（1回だけ）
    "#{Rails.application.config.relative_url_root}/users/sign_in"
  end
end
