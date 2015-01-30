class Subscriber < ActiveRecord::Base
  # Creates array of top ten posts from reddit's front page. Each post has attributes in a hash.
  def self.top_ten
    @front = RedditKit.front_page(options = {:limit => 10})
  end

  # Saves each individual post as a new record to db
  def self.save_top_ten
    Subscriber.top_ten.each do |post|
      new_sub = Subscriber.new
      new_sub.title = post.title.html_safe
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

  # Get the top ten title score has for past x number of minutes
  def self.title_score_hash_timeframe(x)
    # Check if the number of minutes is 0 or null and just return the latest from reddit right now
    if !x.present? or x.to_i == 0
      return title_score_hash
    end
    # If the number of minutes is greater than 0 and a valid integer search the database for x number of minutes
    ten_hash = {}
    topten = Subscriber.where('created_at > ?', Time.now.utc - x.to_i.minutes).order(count: :desc).to_a.uniq{ |item| item.title }[0..9] rescue nil
    if !topten.nil?
      topten.each do |t|
        ten_hash["#{t.title}"] = t.count
      end
    else
      return nil
    end
    return ten_hash
  end
end
