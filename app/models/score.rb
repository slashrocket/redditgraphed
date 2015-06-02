class Score < ActiveRecord::Base
  belongs_to :subscriber

  def self.count_intervals(interval_length)
    first_created = all.last.created_at
    last_created = all.first.created_at
    minutes_apart = (
      (last_created.minus_with_coercion(first_created)
      ).floor / 60)
    (minutes_apart / interval_length).floor
  end

  # Returns the average score of records within a given interval in minutes
  #
  def self.interval_average(int_begin, int_end)
    scores = all.where(created_at: int_begin..int_end)
    return 0 unless scores.present?
    scores.average(:score).floor
  end

  # Returns a hash. The value is the average score for the interval length
  # given in minutes starting from the time indicated by the key
  #
  def self.interval_averages(interval_length)
    result = {}
    int_begin = all.last.created_at
    (0..all.count_intervals(interval_length)).each do
      int_end = int_begin + interval_length.minutes
      average = all.interval_average(int_begin, int_end)
      result.merge!(int_begin.strftime('%I:%M%p') => average)
      int_begin = int_end
    end
    result
  end

  # Returns the average score for the hour beginning x hours ago.
  #
  def self.hour_average(hours_ago)
    hour_begin = hours_ago.hours.ago
    hour_end = (hours_ago - 1).hours.ago
    scores = all.where(created_at: hour_begin..hour_end)
    return 0 unless scores.present?
    scores.average(:score).floor
  end

  # Returns an array of the average scores for each hour starting
  # from x hours ago.
  #
  def self.hour_averages(hours_ago)
    result = []
    (1..hours_ago).each do |n|
      result << all.hour_average(n)
    end
    result
  end
end
