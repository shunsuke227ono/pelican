namespace :rss do
  desc "get rss basic information and store it to db"
  task :get_livedoor => :environment do
    ActiveRecord::Base.transaction do
      Settings.rss.livedoor.full.each do |category_info|
        category = category_info[0]
        category_id = Article.categories[category]
        url = category_info[1][:url]
        feed = Feedjira::Feed.fetch_and_parse url
        if category_info[1][:has_summary]
          feed.entries.each do |entry|
            next if Article.find_by(category: category_id, url: entry.url).present?
            article = {
              category: category_id,
              title: entry.title,
              url: entry.url,
              summary: entry.summary,
              content: entry.content
            }
            Article.create!(article)
          end
        else
          original_url = Settings.rss.livedoor.try(category)[:url]
          original_feed = Feedjira::Feed.fetch_and_parse original_url
          articles = []
          original_feed.entries.each do |entry|
            next if Article.find_by(category: category_id, url: entry.url).present?
            article = {
              category: category,
              title: entry.title,
              url: entry.url,
              summary: entry.summary,
              content: nil
            }
            articles << article;
          end
          feed.entries.each do |entry|
            next if Article.find_by(category: category_id, url: entry.url).present?
            articles.each_with_index do |article, i|
              if article[:url] == entry.url
                # contentがsummaryの代わりに入ってる
                article[:content] = entry.summary
                Article.create!(article)
                # OPTIMIZE bulk insertなどで高速化できる
              end
            end
          end
        end
      end
    end
  end
  task :get_similar_articles => :environment do
    ActiveRecord::Base.transaction do
      Settings.rss.similar_articles.each do |similar_article|
        # FIXME 他カテゴリも対応可能にする
        category = :sport
        url = similar_article[1].full.try(category)[:url]
        category_id = SimilarArticle.categories[category]
        feed = Feedjira::Feed.fetch_and_parse url
        feed.entries.each do |entry|
          SimilarArticle.create!(
            category: category_id,
            title: entry.title,
            url: entry.url,
            summary: entry.summary,
            content: entry.content
          )
          # 類似度分析はcontentで行うので、
          # summaryは機能拡大する時にあれば便利かも的な
        end
      end
    end
  end
end
