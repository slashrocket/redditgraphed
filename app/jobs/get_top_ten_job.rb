class GetTopTenJob < ActiveJob::Base
  after_perform do
    GetTopTenJob.set(wait: 5.minute).perform_later
  end
  queue_as :default

  def perform(*)
    Subscriber.save_top_ten
  end
end
GetTopTenJob.perform_now
