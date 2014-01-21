class ClassificationsController < ApplicationController

  def new
    # tweet = Tweet.where("category IS NULL").all_tags(:date, :location).order("RANDOM()").first
    tweet = Tweet.where(:category => "matched").order("created_at ASC").first
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
