class HomeController < ApplicationController
  def index
    # Get the top 10 posts on the front page in the format of {title: upvotes}
    @subscriber = Subscriber.title_score_hash
    # Sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
  end
end
