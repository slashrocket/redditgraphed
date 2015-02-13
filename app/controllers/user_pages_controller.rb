class UserPagesController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
  def index
  end

  def show
    @user = User.find(params[:id])
  end
end
