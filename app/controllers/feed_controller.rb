class FeedController < ApplicationController
  def index(category="top", page=1, realtime=false)
    if realtime
      url = Settings.rss.livedoor.full.try(params[:category])
      @feed = Feedjira::Feed.fetch_and_parse @url
    else
      category_id = Article.categories[category.to_sym]
      @feed = Article.includes(:similar_articles).where(category: category_id, has_recommendation: true).order('created_at DESC').page(page).per(12)
    end
  end
end
