namespace :rss do
  desc "get rss basic information and store it to db"
  task :get_info => :environment do
    ActiveRecord::Base.transaction do
      Settings.rss.livedoor.full.each do |category_and_url|
        category = category_and_url[0]
        url = category_and_url[1]
        feed = Feedjira::Feed.fetch_and_parse url
        feed.entries.each do |entry|
          article = {
            category: category,
            title: entry.title,
            url: entry.url,
            summary: entry.summary,
            content: entry.content
          }
          p article[:category]
          Article.create!(article)
        end
      end
    end
  end
end
