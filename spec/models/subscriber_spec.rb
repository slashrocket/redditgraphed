require 'rails_helper'

describe Subscriber do
  let(:subscriber) { Subscriber.new }

  describe '#slug' do
    let(:title) { "Reddit post title" } 
    before do
      subscriber.title = title
      subscriber.save
    end

    it 'should parameterize the title' do
      expect(subscriber.slug).to_not eq title
      expect(subscriber.slug).to eq title.downcase.gsub(' ', '-').parameterize
    end
  end

  describe '#to_param' do
    before do
      title = "Reddit post title"
      subscriber.title = title
      subscriber.save
    end

    it 'should append the id to the slug' do
      expect(subscriber.to_param).to eq "#{subscriber.id}-#{subscriber.slug}"
    end
  end

  describe '#record_score' do
    before do
     subscriber.count = 10
     subscriber.save
   end

    it 'should create a new score record' do
      expect { subscriber.record_score(100) }.to change(Score, :count).by(1)
    end

    it 'should update count when the score is higher' do
      expect { subscriber.record_score(100) }.to change(subscriber, :count).by(90)
    end

    it 'should not update count when the score is lower' do
      expect { subscriber.record_score(1) }.to_not change(subscriber, :count)
    end
  end

  describe '#top_ten' do
    it 'should return 10 items' do
      expect(Subscriber.top_ten.count).to eq(10)
    end
  end

  describe '#save_top_ten' do
    describe 'when no records exist' do
      it 'should create 10 new subscriber records' do
        expect { Subscriber.save_top_ten }.to change(Subscriber, :count).by(10)
      end

      it 'should create 10 new score records' do
        expect { Subscriber.save_top_ten }.to change(Score, :count).by(10)
      end
    end

    describe 'when records exist' do
      before { Subscriber.save_top_ten }

      it 'should not create any new subscriber records' do
        expect { Subscriber.save_top_ten }.to_not change(Subscriber, :count)
      end

      it 'should create 10 new score records' do
        expect { Subscriber.save_top_ten }.to change(Score, :count).by(10)
      end
    end
  end

  describe '#title_score_hash_timeframe' do
    describe 'when no records are present' do
      it 'should return nil' do
        expect(Subscriber.title_score_hash_timeframe(5)).to eq nil
      end
    end

    describe 'when records are present' do
      before { Subscriber.save_top_ten }

      it 'should return a hash of 10 items' do
        top_ten = Subscriber.title_score_hash_timeframe(5)
        expect(top_ten.count).to eq 10
      end
    end
  end

  it '#hashify' do
    # expect(Subscriber.hashify('Missing "x"')).to eq('Fill this in by hand')
  end

  describe '#pasthours' do
    let(:subscriber) { Subscriber.first }
    before do
      Subscriber.save_top_ten
    end

    it "should return a hash with scores for each hour ago" do
      scores = Subscriber.pasthours(subscriber, 3)
      expect(scores[0]).to eq subscriber.count
      expect(scores[1]).to eq 0
      expect(scores[2]).to eq 0
    end
  end

  describe '#pastminutes' do
    let(:subscriber) { Subscriber.first }
    before do
      Subscriber.save_top_ten
      Subscriber.first.record_score(100)
      Subscriber.first.scores.last.update_attribute(:created_at, 16.minutes.ago)
      Subscriber.first.record_score(90)
      Subscriber.first.scores.last.update_attribute(:created_at, 32.minutes.ago)
    end

    it 'should return a hash with scores' do
      scores = Subscriber.pastminutes(subscriber, 15)
      expect(scores.size).to eq 3
      scores.each do |k, v|
        expect(v).to be_an Integer
        expect(k).to be_a String
      end
    end
  end

  describe '#doughnut_data' do
    it 'should return a hash of post counts per subreddit' do
      3.times do |n|
        2.times do
          Subscriber.create(title: "post #{n}", author: "author", subreddit: "subreddit #{n}")
        end
      end
      results = Subscriber.doughnut_data('post 1')
      expect(results.size).to eq 3
      results.each do |k, v|
        expect(v).to eq 2
      end
    end
  end

  describe '#user_top_posts' do
    it 'should return a hash of post counts per subreddit' do
      3.times do |n|
        2.times do
          Subscriber.create(title: "post #{n}", author: "author", subreddit: "subreddit #{n}")
        end
      end
      results = Subscriber.user_top_posts('author')
      expect(results.size).to eq 3
      results.each { |k, v| expect(v).to eq 2 }
    end
  end

  describe '#subreddit_popularity' do
    it 'should return an array of the number of apperances for each day' do
      7.times do |n|
        2.times do
          Subscriber.create(subreddit: 'subreddit')
          Subscriber.last.update_attribute(:created_at, n.days.ago)
        end
      end
      results = Subscriber.subreddit_popularity('subreddit', 7)
      expect(results.size).to eq 7
      results.each do |count|
        expect(count).to eq 2
      end 
    end
  end
end
