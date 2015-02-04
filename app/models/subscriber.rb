class Subscriber < ActiveRecord::Base

  # Creates array of top ten posts from reddit's front page. Each post has attributes in a hash.
  def self.top_ten
    return RedditKit.front_page(options = {:limit => 10})
  end

  # Saves each individual post as a new record to db -- this is run every 1 minute as a sidekiq job
  def self.save_top_ten
    self.top_ten.each do |post|
      new_sub = Subscriber.new
      new_sub.title = post.title.html_safe
      new_sub.count = post.score
      new_sub.subreddit = post.subreddit
      new_sub.author = post.author
      new_sub.save!
    end
  end

  # Get the top ten title score has for past x number of minutes
  def self.title_score_hash_timeframe(x)
    # Check if the number of minutes is 0 or null and just return the latest from reddit right now
    if !x.present? or x.to_i == 0
      return title_score_hash
    end
    # If the number of minutes is greater than 0 and a valid integer search the database for x number of minutes
    ten_hash = {}
    topten = self.where('created_at > ?', Time.now.utc - x.to_i.minutes).order(count: :desc).to_a.uniq{ |item| item.title }[0..9] rescue nil
    if !topten.nil?
      topten.each do |t|
        ten_hash["#{t.title}"] = t.count
      end
    end
    return ten_hash
  end

  def self.hashify(x)
    hash = {}
    x.each do |t|
      hash["#{t.title}"] = t.score
    end
    hash = Hash[hash.sort_by{|k, v| v}.reverse]
    return hash
  end

  def self.clicked_post(title)
    postsfound = self.where("title LIKE ?", title) rescue nil
  end

  # Test me with: Subscriber.doughnut_data(Subscriber.last.title)
  def self.doughnut_data(title)
    op = self.find_by_title(title).author # Find the author based on the title
    op_posts = self.where("author = ?", op) # Get all op's posts
    op_posts_unique = op_posts.to_a.uniq{ |item| item.title } # Only get unique posts
    op_subreddits = op_posts_unique.map(&:subreddit)
    # Count the number of similar subreddits
    countsubreddits = Hash.new 0
    op_subreddits.each { |word| countsubreddits[word] += 1 } # Iterate through the array, adding +1 each time a same subreddit is seen
    return countsubreddits # Return the hashed results
  end

  # Test me with: Subscriber.user_top_posts(Subscriber.last.author)
  def self.user_top_posts(author)
    op_posts = self.where("author = ?", author) # Get all op's posts
    op_posts_unique = op_posts.to_a.uniq{ |item| item.title } # Only get unique posts
    op_subreddits = op_posts_unique.map(&:subreddit)
    # Count the number of similar subreddits
    countsubreddits = Hash.new 0
    op_subreddits.each { |word| countsubreddits[word] += 1 } # Iterate through the array, adding +1 each time a same subreddit is seen
    return countsubreddits # Return the hashed results
  end

  # Test me with: Subscriber.subreddit_popularity(Subscriber.last.subreddit, 7)
  def self.subreddit_popularity(subreddit, days)
    days = days.to_i
    day = Time.now.utc - days.days
    all_posts = self.where("subreddit = ? AND created_at > ?", subreddit, day)
    all_posts_unique = all_posts.to_a.uniq{ |item| item.title } # Only get unique posts
    subreddits = all_posts_unique.map(&:subreddit)
    # Count the number of similar subreddits
    results = {}
    while days >= 0 do
      iteration_days = Time.now.utc - days
      todaysposts = all_posts.where('created_at > ? AND created_at < ?', iteration_days, iteration_days - 1.days).count
      results[days] = todaysposts
      days -= 1
    end
    return results
  end
end
