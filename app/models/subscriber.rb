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
      foundindatabase = self.find_by_title(CGI::escapeHTML(post.title)) rescue nil
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
        new_sub.title = CGI::escapeHTML(post.title)
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
    if x.to_i < 5 then x = 5 end
    # If the number of minutes is greater than 0 and a valid integer search the database for x number of minutes
    topten = Subscriber.where(updated_at: x.to_i.minutes.ago..Time.now).order(count: :desc).limit(10).pluck(:title, :count) rescue nil
    unless topten.present? then return nil end
    return Hash[topten]
  end

  def self.hashify(x)
    hash = {}
    x.each do |t|
      hash["#{t.title}"] = t.score
    end
    hash = Hash[hash.sort_by{|k, v| v}.reverse]
    return hash
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

  #input the subscriber model object and the number of minutes between data points
  #output a hash of the minutes and the average score for those minutes per data point
  def self.pastminutes(sub, minute)
    #get all scores based on a subscriber entry and order them decending
    allscores = sub.scores.select(:score, :created_at).order(created_at: :DESC)
    #get the first scores created_at time
    firstscoretime = allscores.last.created_at
    #get the last scores created_at time
    lastscoretime = allscores.first.created_at
    #find out how far apart they are in minutes
    minutesapart = ((lastscoretime.minus_with_coercion(firstscoretime)).floor / 60)
    #find out how many times we will have to loop
    loopcount = (minutesapart / minute).floor
    #create a blank result array
    result = {}
    #keep track of the previously used datetime in the loop
    timelast = firstscoretime
    #iterate through the number of desired minutes to check based on the start/end time
    (0..loopcount).each do |x|
      #get the current time we want to check 'up to' in the sql where statement
      currenttime = timelast + minute.minutes
      #search the scores by the time block and then only return the score as a number in an array
      thisminute = allscores.where(created_at: timelast..currenttime).pluck(:score) rescue nil
      #if we find something from the sql request
      if thisminute.present?
        #find out the average of the found scores for that time block
        thisminuteaverage = thisminute.sum.to_f / thisminute.size
        #make the result a whole number before saving it to the result array
        result.merge!(timelast.strftime("%I:%M%p") => thisminuteaverage.floor)
      end
      #update the previously used datetime in the loop before iterating again
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
  def self.subreddit_popularity(sub, daycount)
    sql_query = self.where(subreddit: sub, created_at: daycount.days.ago..Time.now)
    # Return unsorted hash: date => number of appearance
    hash_result = sql_query.group_by_day(:created_at, range: (daycount.days.ago + 1.day)..Time.now).count.values
    return hash_result
  end
end
