class PostController < ApplicationController
  def show
    @post = Subscriber.find(show_params)
    @author_posts = Subscriber.where('author = ?', @post.author).count
    @scrapes = @post.scores
    @timeframe = { '5 minutes' => 5,
                   '10 minutes' => 10,
                   '15 minutes' => 15,
                   '30 minutes' => 30,
                   '45 minutes' => 45,
                   'hour' => 60 }
    @chartone = @post.pastminutes(10)
  end

  def timeframe
    @post = Subscriber.find(time_params[:title])
    @time = time_params[:time].to_i
    @chartone = Subscriber.pastminutes(@post, @time)
    render partial: 'post/chartdata.js.erb'
  end

  private

  def show_params
    params.require(:title)
  end

  def time_params
    params.permit(:title, :time)
  end
end
