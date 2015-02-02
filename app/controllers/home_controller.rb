class HomeController < ApplicationController
  def index
    # Get the top 10 posts on the front page in the format of {title: upvotes}
    @subscribersorted = Subscriber.hashify(Subscriber.top_ten)
    # Timeframes allowed in current dropdown list
    @timeframe = {'minute' => 2, '5 minutes' => 5, '30 minutes' => 30, '1 hour' => 60, '6 hours' => 360, '12 hours' => 720, '24 hours' => 1440}
  end

  def timeframe
    # Get the timeframe we'll be using in minutes from the url
    @time_in_minutes = params[:time]
    # Get the top 10 posts on the front page in the format of {title: upvotes} for this timeframe
    @subscriber = Subscriber.title_score_hash_timeframe(@time_in_minutes) rescue nil
    #if we dont get at least 10 results back, we dont have proper DB data, kick back an alert message and redirect
    if !@subscriber.present? or @subscriber.count != 10
      return render partial: 'home/nodata.js.erb'
    end
    # Sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
    # Render the new results on the page
    render partial: 'home/chartdata.js.erb'
  end

  def title
    # Get the title we'll be using from the url
    @title = params[:title]
    databytitle = Subscriber.find_by_title(@title)
    @op = databytitle.author
    @subreddit_name = databytitle.subreddit
    @op_subreddit_data = Subscriber.doughnut_data(@title)
    # Find all DB entries matching the title
    postsfound = Subscriber.where("title == ?", @title) rescue nil #<---- this should be moved to the model i think

    #if an error occured or we couldnt find anything, alert the user
    if postsfound.nil?
      return render partial: 'home/nodata.js.erb'
    end

    # Get the top 10 posts on the front page in the format of {title: upvotes} for this timeframe
    @subscribersorted = Subscriber.hashify(Subscriber.top_ten)
    # Find all records that have same title as passed param
    @post_title = Subscriber.where("title == ?", params[:title])
    # Render the new results on the page
    render partial: 'home/renderchartdetails.js.erb'
  end
end
