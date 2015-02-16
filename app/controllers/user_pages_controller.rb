class UserPagesController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
  def index
    @saved = current_user.saved.pluck(:subscriber_id)
  end

  def show
    @user = User.find(params[:id])
    @saved = @user.saved.pluck(:subscriber_id)
  end

  def save
    if current_user.saved.find_by_subscriber_id(params[:id].to_i)
      flash[:alert] = "Post has already been saved"
      return redirect_to dashboard_path
    end
    saved = Saved.new
    saved.user_id = current_user.id
    saved.subscriber_id = params[:id].to_i
    if saved.save
      flash[:notice] = "Successfully saved to your dashboard"
      return redirect_to root_path
    else
      flash[:alert] = "Error saving, please try again"
      return redirect_to root_path
    end
  end
end
