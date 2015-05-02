class SearchController < ApplicationController
  require 'will_paginate/array'

  def results
    @searchedfor = params[:search][:text].html_safe
    @resultsfound = Subscriber.search(@searchedfor,
                                      limit: 25,
                                      misspellings: { distance: 1 },
                                      fields: ['title^20'])
    @resultsfound  = Subscriber.search('*', limit: 25) if @searchedfor.empty?
  end
end
