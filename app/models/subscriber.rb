class Subscriber < ActiveRecord::Base
  def self.getreddits(username,password)
    user = RedditKit::Client.new u, p
    subreddits = user.subscribed_subreddits
    sub = {}
    subreddits.each do |s|
      sub[:"#{s.url}"] = s.subscribers
    end
    puts sub.sort_by { |k,v| k }
  end
  
  puts 'Username: '
  u = gets.chomp
  puts 'Password: '
  p = gets.chomp
  reddit(u,p)
end
