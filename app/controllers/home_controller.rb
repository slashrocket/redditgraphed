class HomeController < ApplicationController
  def index
  end

  def new
    @subscriber = Subscriber.top_ten_hash
  end
end
