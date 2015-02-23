class HomeController < ApplicationController
  def index
    # Get the top 10 posts on the front page in the format of {title: upvotes}
    @subscribersorted = Subscriber.hashify(Subscriber.top_ten)
    # Timeframes allowed in current dropdown list
    @timeframe = {'5 minutes' => 5, '30 minutes' => 30, '1 hour' => 60, '6 hours' => 360, '12 hours' => 720, '24 hours' => 1440}
  end

  def timeframe
    # Get the top 10 posts on the front page in the format of {title: upvotes} for this timeframe
    @subscriber = Subscriber.title_score_hash_timeframe(params[:time]) rescue nil
    #if we dont get at least 10 results back, we dont have proper DB data, kick back an alert message and redirect
    unless @subscriber.present? then return render partial: 'home/nodata.js.erb' end
    # Sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
    # Render the new results on the page
    render partial: 'home/chartdata.js.erb'
  end

  def title
    # Get the title we'll be using from the url
    @title = Subscriber.find_by_title(params[:title].html_safe)
    #if an error occured or we couldnt find anything, alert the user
    unless @title.present? then return render partial: 'home/nodata.js.erb' end
    #get number of times op has been top 10
    @opcount = Subscriber.where("author = ?", @title.author).count
    #get the subreddit popularity for the past week
    @subreddit_popularity = Subscriber.subreddit_popularity(@title.subreddit, 7)
    #get the past average of a post for x number of hours, in one hour increments
    @subreddit_past = Subscriber.pasthours(@title, 12)
    # Render the new results on the page
    render partial: 'home/renderchartdetails.js.erb'
  end
end
