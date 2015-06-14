namespace :rss do
  desc "get rss basic information and store it to db"
  def only_text(original_html)
    Nokogiri::HTML(original_html).inner_text
  end
  task :get_livedoor => :environment do
    ActiveRecord::Base.transaction do
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
            content: FullContent.article_body(entry.url)
          }
          Article.create!(article)
        end
      end
    end
  end
  task :get_similar_articles => :environment do
    ActiveRecord::Base.transaction do
      Settings.rss.similar_articles.each do |similar_article|
        # FIXME 他カテゴリも対応可能にする
        category = :spo
        url = similar_article[1].full.try(category)[:url]
        category_id = SimilarArticle.categories[category]
        feed = Feedjira::Feed.fetch_and_parse url
        feed.entries.each do |entry|
          SimilarArticle.create!(
            category: category_id,
            title: only_text(entry.title),
            url: only_text(entry.url),
            summary: only_text(entry.summary),
            content: only_text(entry.content)
          )
          # 類似度分析はcontentで行うので、
          # summaryは機能拡大する時にあれば便利かも的な
        end
      end
    end
  end
end
