class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_conf, :current_password)
  end
end
