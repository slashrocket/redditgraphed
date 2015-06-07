require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'should redner the right partial' do
      expect(response).to render_template(:index)
    end

    it 'should get a hash of the top 10 reddit posts' do
      expect(assigns(:subscribers).length).to eq 10
    end
  end

  describe 'POST #title' do
    before do
      3.times do |n|
        Subscriber.create(title: "Post #{n}",
                          author: 'author', 
                          subreddit: 'sub')
      end
    end

    describe 'when post does not exist' do
      before { post :title, title: 'No Post' }

      it 'should render the right partial' do
        expect(response).to render_template(partial: '_nodata.js.erb')
        expect(response).to_not render_template(
          partial: '_renderchartdetails.js.erb')
      end
    end

    describe 'when post exists' do
      before { post :title, title: 'Post 1' }

      it 'should render the right partial' do
        expect(response).to render_template(
          partial: '_renderchartdetails.js.erb')
      end

      it 'should assign the correct variables' do
        expect(assigns :author_posts).to be_kind_of(Integer)
        expect(assigns :popularity).to be_kind_of(Array)
        expect(assigns :past_hours).to be_kind_of(Array)
      end
    end
  end

  describe 'POST #timeframe' do
    before do
      Subscriber.record_timestamps = false
      10.times do |n|
        Subscriber.create(title: "Post #{n}",
                          count: 100,
                          created_at: 10.minutes.ago,
                          updated_at: 10.minutes.ago)
      end
      Subscriber.record_timestamps = true
    end

    describe 'when posts do not exist' do
      before { post :timeframe, time: 5 }

      it 'should render the right partial' do
        expect(response).to render_template(partial: '_nodata.js.erb')
      end
    end

    describe 'when posts exist' do

      it 'should render the right partial' do
        post :timeframe, time: 15
        puts Time.now.utc.to_s
        puts Subscriber.first.updated_at.to_s
        expect(assigns(:subscribers)).to be_present
        expect(response).to render_template(partial: '_chartdata.js.erb')
      end
    end
  end
end
