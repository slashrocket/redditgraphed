class Subscriber < ActiveRecord::Base
  searchkick

  has_many :scores
  has_many :saved

  # Convert post title to friendly url format
  #
  def slug
    title.downcase.gsub(' ', '-').parameterize
  end

  # Change default param for user from id to id-name for friendly urls.
  # When finding in DB, Rails auto calls .to_i on param, which tosses
  # name and doesn't cause any problems in locating user.
  #
  def to_param
    "#{id}-#{slug}"
  end

  # Create new score record for a subscriber record.
  # Sets the subscriber record's high score (count) to the new score if
  # it is higher than the current high score.
  #
  def record_score(score)
    scores.create(score: score)
    if score > count
      update_attribute(:count, score)
    else
      touch
    end
  end

  # Creates array of top ten posts from reddit's front page.
  # Each post has attributes in a hash.
  #
  def self.top_ten
    RedditKit.front_page(limit: 10)
  end

  # Saves each of the top ten posts as a new record or adds a score record to
  # an existing record.
  # This is run every 5 minute as a sidekiq job
  #
  def self.save_top_ten
    top_ten.each do |post|
      subscriber = find_by(title: CGI.escapeHTML(post.title))
      if subscriber.present?
        subscriber.record_score(post.score)
      else
        Subscriber.create(params_from(post)).record_score(post.score)
      end
    end
  end

  # Returns a hash the scores for the top ten posts for past
  # x number of minutes
  #
  def self.title_score_hash_timeframe(x)
    x = 5 unless x.to_i > 5
    top_ten = Subscriber.where(updated_at: x.to_i.minutes.ago..Time.now)
              .order(count: :desc)
              .limit(10)
              .pluck(:title, :count)
    return nil unless top_ten.present?
    Hash[top_ten]
  end

  def self.hashify(x)
    hash = {}
    x.each do |t|
      hash["#{t.title}"] = t.score
    end
    hash = Hash[hash.sort_by { |_k, v| v }.reverse]
    hash
  end

  # Returns an array of the average scores for a subscriber record for
  # each hour during the given interval
  #
  def self.pasthours(subscriber, hours_ago)
    subscriber.scores.hour_averages(hours_ago)
  end

  # Returns a hash of times and the avg score for those times
  # Accepts a subscriber model instance and the desired interval
  # between data points in minutes
  #
  def self.pastminutes(subscriber, interval_length)
    subscriber.scores
      .order(created_at: :DESC)
      .interval_averages(interval_length)
  end

  # Finds an author by the title of a post and returns a hash where the keys are
  # names of subreddits the author submitted posts to and the
  # values are the number of posts submitted to each subreddit.
  #
  def self.doughnut_data(title)
    op = find_by(title: title).author
    user_top_posts(op)
  end

  # Returns a hash where the keys are names of subreddits the author submitted
  # posts to and the values are the number of posts submitted to each subreddit.
  #
  def self.user_top_posts(author)
    op_posts = where(author: author).pluck(:subreddit)
    subreddits = Hash.new 0
    op_posts.each { |word| subreddits[word] += 1 }
    subreddits
  end

  # Returns an array of the number of times a given subreddit appeared on each
  # day of a given interval in order of ascending date.
  #
  def self.subreddit_popularity(sub, daycount)
    where(subreddit: sub)
      .group_by_day(:created_at, last: daycount)
      .count
      .values
  end

  def self.params_from(post)
    {
      title:           CGI.escapeHTML(post.title),
      subreddit:       post.subreddit,
      author:          post.author,
      permalink:       post.permalink,
      post_created_at: post.created_at,
      count:           post.score
    }
  end
end
