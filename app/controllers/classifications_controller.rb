class ClassificationsController < ApplicationController

  def new
    tweet = Tweet.where("category IS NULL").order("RANDOM()").first
    render json: tweet
  end

  def create
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    head :ok
  end

  private

  def tweet_params
    params.require(:tweet).permit(:category)
  end
end
