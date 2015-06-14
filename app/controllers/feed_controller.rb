class FeedController < ApplicationController
  before_action :set_url
  def index
    @feed = Feedjira::Feed.fetch_and_parse @url
  end
  private
  def set_url
    @url = Settings.rss.livedoor.full.try(params[:category])
  end
end
