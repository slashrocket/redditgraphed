class GetTopTenJob < ActiveJob::Base
  RUN_EVERY = 1.minute
  queue_as :default

  def perform(*args)
    Subscriber.save_top_ten
  end
end
GetTopTenJob.set(wait: 1.minute).perform_later