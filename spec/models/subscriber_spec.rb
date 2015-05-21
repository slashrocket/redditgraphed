require 'rails_helper'

describe Subscriber do
  let(:subscriber) do
    Subscriber.new
  end

  it '#slug' do
    expect(subscriber.slug).to eq('Fill this in by hand')
  end

  it '#to_param' do
    expect(subscriber.to_param).to eq('Fill this in by hand')
  end

  it '#top_ten' do
    expect(Subscriber.top_ten).to eq('Fill this in by hand')
  end

  it '#save_top_ten' do
    expect(Subscriber.save_top_ten).to eq('Fill this in by hand')
  end

  it '#title_score_hash_timeframe' do
    expect(Subscriber.title_score_hash_timeframe('Missing "x"')).to eq('Fill this in by hand')
  end

  it '#hashify' do
    expect(Subscriber.hashify('Missing "x"')).to eq('Fill this in by hand')
  end

  it '#pasthours' do
    expect(Subscriber.pasthours('Missing "sub"', 'Missing "hours"')).to eq('Fill this in by hand')
  end

  it '#pastminutes' do
    expect(Subscriber.pastminutes('Missing "sub"', 'Missing "minute"')).to eq('Fill this in by hand')
  end

  it '#doughnut_data' do
    expect(Subscriber.doughnut_data('Missing "title"')).to eq('Fill this in by hand')
  end

  it '#user_top_posts' do
    expect(Subscriber.user_top_posts('Missing "author"')).to eq('Fill this in by hand')
  end

  it '#subreddit_popularity' do
    expect(Subscriber.subreddit_popularity('Missing "sub"', 'Missing "daycount"')).to eq('Fill this in by hand')
  end
end
