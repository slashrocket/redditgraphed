class UserPagesController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
  def index
    @saved = current_user.saved.pluck(:subscriber_id)
  end

  def show
    @user = User.find(params[:id])
  end

  def save
    saved = Saved.new
    saved.user_id = current_user.id
    saved.subscriber_id = params[:id].to_i
    if saved.save
      flash[:notice] = "Successfully saved to your dashboard"
      return redirect_to root_path
    else
      flash[:warning] = "Error saving, please try again"
      return redirect_to root_path
    end
  end

end