class PostController < ApplicationController
  def show
    @post = Subscriber.find(params[:title])
    @scrapes = @post.scores
  end
end
