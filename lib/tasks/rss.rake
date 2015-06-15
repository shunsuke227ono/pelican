namespace :rss do
  desc "get rss basic information and store it to db"
  def only_text(original_html)
    Nokogiri::HTML(original_html).inner_text
  end
  task :get_livedoor => :environment do
    ActiveRecord::Base.transaction do
      p "=========start get_livedoor=========="
      Settings.rss.livedoor.each do |category_info|
        category = category_info[0]
        category_id = Article.categories[category]
        url = category_info[1][:url]
        feed = Feedjira::Feed.fetch_and_parse url
        feed.entries.each do |entry|
          next if Article.find_by(category: category_id, url: only_text(entry.url)).present?
          article = {
            category: category_id,
            title: only_text(entry.title),
            url: only_text(entry.url),
            summary: only_text(entry.summary),
            content: FullContent.article_body(entry.url, :livedoor)
          }
          Article.create!(article)
        end
      end
    end
  end
  task :get_yahoo => :environment do
    ActiveRecord::Base.transaction do
      p "=========start get_yahoo=========="
      category = :spo
      Settings.rss.yahoo.spo.each do |rss_url|
        category_id = SimilarArticle.categories[category]
        feed = Feedjira::Feed.fetch_and_parse rss_url
        feed.entries.each do |entry|
          next if SimilarArticle.find_by(category: category_id, url: entry.url).present?
          SimilarArticle.create!(
            category: category_id,
            title: only_text(entry.title),
            url: only_text(entry.url),
            summary: only_text(entry.summary),
            content: FullContent.article_body(entry.url, :yahoo)
          )
        end
      end
    end
  end
end
