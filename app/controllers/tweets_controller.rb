class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def index
      @tweets = Tweet.all
      search = params[:search]
      @tweets = @tweets.joins(:user).where("body LIKE ?", "%#{search}%") if search.present?
      @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).tweets : Tweet.all
  end
  def new
      @tweet = Tweet.new
  end

  def create
    tweet = Tweet.new(tweet_params)
    tweet.user_id = current_user.id
    if tweet.save
      redirect_to :action => "index"
    else
      edirect_to :action => "new"
    end
  end
  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end
  def show
      @tweet = Tweet.find(params[:id])
    end
  private
  def tweet_params
      params.require(:tweet).permit(:body, :place, tag_ids: [])
  end
end


