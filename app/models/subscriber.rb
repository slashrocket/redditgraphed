class Subscriber < ActiveRecord::Base
  # Pulls top ten posts from reddit front page
  def self.top_ten
    front = RedditKit.front_page(options = {:limit => 10})
  end
end
