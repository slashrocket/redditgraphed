class Subscriber < ActiveRecord::Base
  # Creates array of top ten posts from reddit's front page. Each post has attributes in a hash.
  def self.top_ten
    @front = RedditKit.front_page(options = {:limit => 10})
  end

  # Saves each individual post as a new record to db
  def self.save_top_ten
    Subscriber.top_ten.each do |post|
      new_sub = Subscriber.new
      new_sub.title = post.title
      new_sub.count = post.score
      new_sub.subreddit = post.subreddit
      new_sub.save!
    end
  end

  # Creates hash with title as key and score as value
  def self.title_score_hash
    ten_hash = {}
    top_ten.each do |t|
      ten_hash["#{t.title}"] = t.score
    end
    return ten_hash
  end

  #get the top ten title score has for past x number of minutes

  def self.title_score_hash_timeframe(x)
    ten_hash = {}
    topten = Subscriber.where('created_at > ?', Time.now.utc - x.to_i.minutes).order(count: :desc).to_a.uniq{ |item| item.title }[0..9]
    topten.each do |t|
      ten_hash["#{t.title}"] = t.count
    end
    return ten_hash
  end
end
