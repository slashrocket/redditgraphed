class Subscriber < ActiveRecord::Base
  # Pulls top ten posts from reddit front page
  def self.top_ten
    @front = RedditKit.front_page(options = {:limit => 10})
  end
  # Creates hash with title as key and score as value
  def self.title_score_hash
    ten_hash = {}
    top_ten.each do |t|
      ten_hash[:"#{t.title}"] = t.score
    end
    return ten_hash
  end
end
