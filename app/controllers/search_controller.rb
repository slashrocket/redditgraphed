class SearchController < ApplicationController
  require 'will_paginate/array'

  def index
  end

  def results
    @searchedfor = params[:search][:text].html_safe
    @resultsfound = Subscriber.search(@searchedfor,
                         limit: 25,
                         partial: true,
                         misspellings: {distance: 2},
                         fields: ['title^20',
                                  'subreddit^3',
                                  'author^10'])
    if @searchedfor.empty?
      @resultsfound  = Subscriber.search('*', limit: 25)
    end
  end
end
