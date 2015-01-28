class HomeController < ApplicationController
  def index
    # Get the top 10 posts on the front page in the format of {title: upvotes}
    @subscriber = Subscriber.title_score_hash
    # Sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
    #timeframes allowed in current dropdown list
    @timeframe = {'now' => 0, '5 minutes' => 5, '30 minutes' => 30, '1 hour' => 60, '6 hours' => 360, '12 hours' => 720, '24 hours' => 1440}
  end

  def timeframe
    #get the timeframe we'll be using in minutes from the url
    @time_in_minutes = params[:time]
    # Get the top 10 posts on the front page in the format of {title: upvotes} for this timeframe
    @subscriber = Subscriber.title_score_hash_timeframe(@time_in_minutes)
    # Sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
    #render the new results on the page
    render partial: 'home/timeframe.js.erb'
  end
end
