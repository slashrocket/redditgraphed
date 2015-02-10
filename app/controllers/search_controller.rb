class SearchController < ApplicationController
  def index
  end

  def results
    searchfor = params[:search][:text]
    @resultsfound = Subscriber.search searchfor.html_safe, page: params[:page], per_page: 5
  end
end
