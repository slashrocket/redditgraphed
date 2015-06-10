class HomeController < ApplicationController
  def index
    @subscribers = Subscriber.hashify(Subscriber.top_ten)
    # Timeframes allowed in current dropdown list
    @timeframe = { '5 minutes'  => 5,
                   '30 minutes' => 30,
                   '1 hour'     => 60,
                   '6 hours'    => 360,
                   '12 hours'   => 720,
                   '24 hours'   => 1440 }
  end

  def timeframe
    @subscribers = Subscriber.title_score_hash_timeframe(time_params)
    if @subscribers
      render partial: 'chartdata.js.erb'
    else 
      render partial: 'nodata.js.erb'
    end
  end

  def title
    @title = Subscriber.find_by_title(CGI.escapeHTML(title_params))
    return render partial: 'nodata.js.erb' unless @title.present?
    @author_posts = Subscriber.where(author: @title.author).count
    @popularity = Subscriber.subreddit_popularity(@title.subreddit, 7)
    @past_hours = @title.pasthours(12)
    render partial: 'renderchartdetails.js.erb'
  end

  private

  def time_params
    params.require(:time)
  end

  def title_params
    params.require(:title)
  end
end
