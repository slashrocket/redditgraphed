class PostController < ApplicationController
  def show
    @post = Subscriber.find(params[:title])
    @scrapes = @post.scores
    @timeframe = {'5 minutes' => 5, '10 minutes' => 10, '15 minutes' => 15, '30 minutes' => 30, '45 minutes' => 45, 'hour' => 60}
    @chartone = Subscriber.pastminutes(@post, 10)
  end

  def timeframe
    @post = Subscriber.find(params[:title])
    @time = params[:time].to_i
    @chartone = Subscriber.pastminutes(@post, @time)
    render partial: 'post/chartdata.js.erb'
  end
end
