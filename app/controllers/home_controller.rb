class HomeController < ApplicationController
  def index
  end

  def new
    @subscriber = Subscriber.title_score_hash
  end
end
