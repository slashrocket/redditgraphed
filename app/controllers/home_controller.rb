class HomeController < ApplicationController
  def index
    #get the top 10 posts on the front page in the format of {title: upvotes}
    @subscriber = Subscriber.title_score_hash
    #sort by upvote count (the value of hash)
    @subscribersorted = Hash[@subscriber.sort_by{|k, v| v}.reverse]
    #@sub2 = Subscriber.save_top_ten move this to a bg process
  end

  def new
    #get the top 10 posts on the front page in the format of {title: upvotes}
    @subscriber = Subscriber.title_score_hash
  end
end
