class TopController < ApplicationController
  def index
    url = "http://news.livedoor.com/topics/rss/top.xml"
    @feed = Feedjira::Feed.fetch_and_parse url
  end
end
