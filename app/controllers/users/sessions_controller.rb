class Users::SessionsController < Devise::SessionsController
before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # super
  end

  # POST /resource/sign_in
  def create
    # super
    # user = sign_in(params[:email], params[:password])
    if user_signed_in?
      flash[:success] = "Logged in"
      redirect_to root_url
    else
      flash[:warning] = "Email or password was invalid"
      redirect_to login_url
    end
  end

  # DELETE /resource/sign_out
  def destroy
    sign_out
    flash[:success] = "Logged out"
    redirect_to root_url
  end

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end
end
