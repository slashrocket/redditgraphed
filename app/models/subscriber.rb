class Subscriber < ActiveRecord::Base
  has_many :scores
  has_many :saved

  # Convert post title to friendly url format
  def slug
    title.downcase.gsub(" ", "-").parameterize
  end

  # Change default param for user from id to id-name for friendly urls.
  # When finding in DB, Rails auto calls .to_i on param, which tosses
  # name and doesn't cause any problems in locating user.
  def to_param
    "#{id}-#{slug}"
  end

  searchkick #import searchkick gem into this model
  # Creates array of top ten posts from reddit's front page. Each post has attributes in a hash.
  def self.top_ten
    return RedditKit.front_page(options = {:limit => 10})
  end

  # Saves each individual post as a new record to db -- this is run every 5 minute as a sidekiq job
  def self.save_top_ten
    #get the top ten reddit posts and iterate through them as objects
    self.top_ten.each do |post|
      #check if this post already exists in the database
      foundindatabase = self.find_by_title(post.title.html_safe) rescue nil
      #if its found, only save its current score
      if foundindatabase.present?
        new_score = Score.new
        new_score.subscriber_id = foundindatabase.id
        new_score.score = post.score
        new_score.save!
        #if the current score is higher than the saved score, save it as highest
        if post.score > foundindatabase.count
          foundindatabase.count = post.score
          foundindatabase.save!
        else
          #update the updated_at timestamp for the subscriber in the db
          foundindatabase.touch
        end
      #if it isnt found, save it as a new subscriber and then save its score
      else
        new_sub = Subscriber.new
        new_sub.title = post.title.html_safe
        new_sub.subreddit = post.subreddit
        new_sub.author = post.author
        new_sub.permalink = post.permalink
        new_sub.post_created_at = post.created_at
        new_sub.count = post.score
        new_sub.save!
        new_score = Score.new
        new_score.subscriber_id = new_sub.id
        new_score.score = post.score
        new_score.save!
      end
      #reset foundindatabase to nil so it doesnt try to reuse an old variable
      foundindatabase = nil
    end
  end

  # Get the top ten title score has for past x number of minutes
  def self.title_score_hash_timeframe(x)
    # Check if the number of minutes is 0 or null and just return the latest from the last 5 minutes
    if !x.present? or x.to_i < 5 then x = 5 end
    # If the number of minutes is greater than 0 and a valid integer search the database for x number of minutes
    ten_hash = {}
      topten = self.where('updated_at > ?', Time.now.utc - x.to_i.minutes).order(count: :desc)[0..9] rescue nil
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

  def self.pasthours(sub, hours)
    #get all scores based on a subscriber entry
    allscores = sub.scores.select(:score, :created_at)
    #create a blank result array
    result = []
    #iterate through the number of desired hours to check
    (1..hours).each do |x|
      #search the scores by the hour and then only return the score as a number in an array
      thishour = allscores.where("created_at > ? AND created_at < ?", x.hours.ago, (x - 1).hours.ago).pluck(:score) rescue nil
      if thishour.present?
      #find out the average of the found scores for that hour
      thishouraverage = thishour.sum.to_f / thishour.size
      #make the result a whole number before saving it to the result array
        result += [thishouraverage.floor]
      end
    end
    return result
  end

  def self.pastminutes(sub, minute)
    #get all scores based on a subscriber entry
    allscores = sub.scores.select(:score, :created_at)
    allscores.order! 'created_at DESC'
    firstscoretime = allscores.last.created_at
    lastscoretime = allscores.first.created_at
    minutesapart = ((lastscoretime.minus_with_coercion(firstscoretime)).floor / 60)
    loopcount = (minutesapart / minute).floor
    #create a blank result array
    result = []
    #keep track of the previously used datetime we used in the loop
    timelast = firstscoretime
    #iterate through the number of desired minutes to check
    (1..loopcount).each do |x|
      currenttime = timelast + minute.minutes
      #search the scores by the time block and then only return the score as a number in an array
      thisminute = allscores.where("created_at > ? AND created_at < ?", currenttime, timelast).pluck(:score) rescue nil
      if thisminute.present?
        #find out the average of the found scores for that time block
        thisminuteaverage = thisminute.sum.to_f / thisminute.size
        #make the result a whole number before saving it to the result array
        result += [thisminuteaverage.floor]
      end
      timelast = currenttime
    end
    return result
  end

  # Test me with: Subscriber.doughnut_data(Subscriber.last.title)
  def self.doughnut_data(title)
    op = self.find_by_title(title).author # Find the author based on the title
    op_posts = self.where("author = ?", op).pluck(:subreddit) # Get all op's posts
    # Count the number of similar subreddits
    countsubreddits = Hash.new 0
    op_posts.each { |word| countsubreddits[word] += 1 } # Iterate through the array, adding +1 each time a same subreddit is seen
    return countsubreddits # Return the hashed results
  end

  # Test me with: Subscriber.user_top_posts(Subscriber.last.author)
  def self.user_top_posts(author)
    op_posts = self.where("author = ?", author).pluck(:subreddit) # Get all op's posts
    # Count the number of similar subreddits
    countsubreddits = Hash.new 0
    op_posts.each { |word| countsubreddits[word] += 1 } # Iterate through the array, adding +1 each time a same subreddit is seen
    return countsubreddits # Return the hashed results
  end

  # Return array containing days of the week(as a number) and the number of times that subreddit appeared that day.
  def self.subreddit_popularity(subreddit, days = 7)
    # Begining of the past week.
    start_date = days.days.ago.midnight
    sql_query = "subreddit = '#{subreddit}' AND created_at > '#{days.days.ago.midnight}'"
    # Return unsorted hash: date => number of appearance
    hash_result = self.where(sql_query).select(:title).group("DATE(created_at)").count
    # Sort by date, replace date with number (7 is the oldest day, 1 is today) and return array with results
    array_result = hash_result.sort.each {|item| item[0] = days; days -= 1}
  end
end
