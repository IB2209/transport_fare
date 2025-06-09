class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:user_id]
         
  enum :role, { general: 0, staff: 1, admin: 2 }

  validates :name, presence: true
  validates :user_id, presence: true

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def admin?
    user_id == "admin"
  end
  
  def staff?
    user_id == "staff"
  end
end
