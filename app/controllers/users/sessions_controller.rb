class Users::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create ]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end
end
