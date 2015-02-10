class SearchController < ApplicationController
  require 'will_paginate/array'
  
  def index
  end

  def results
    @searchedfor = params[:search][:text]
    @resultsfound = Subscriber.search @searchedfor.html_safe, limit: 100
    @resultsfoundunique = @resultsfound.to_a.uniq{ |item| item.title }
  end
end
