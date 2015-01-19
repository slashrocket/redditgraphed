class GetTopTenJob < ActiveJob::Base
  after_perform do |job|
    GetTopTenJob.set(wait: 1.minute).perform_later
  end
  queue_as :default

  def perform(*args)
    Subscriber.save_top_ten
  end
end
GetTopTenJob.perform_now