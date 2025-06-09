# app/controllers/users/registrations_controller.rb

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # 新規登録時に許可するパラメータ
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_id, :role])
  end

  # アカウント更新時に許可するパラメータ
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_id, :role])
  end
end
