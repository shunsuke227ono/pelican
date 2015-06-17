namespace :rss do
  desc "get rss basic information and store it to db"
  def only_text(original_html)
    Nokogiri::HTML(original_html).inner_text
  end
  def update_summary?(article, entry_summary)
    article.summary != entry_summary
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
          entry_url = only_text(entry.url)
          entry_summary = only_text(entry.summary)
          article = Article.find_by(category: category_id, url: entry_url)
          if article.present?
            article.update!(summary: entry_summary) if update_summary?(article, entry_summary)
          else
            img_and_article_body = FullContent.img_and_article_body_and_html(entry.url)
            # FIXME htmlとるかこの方法そもそもhtml見ないか。
            article_attr = {
              category: category_id,
              title: only_text(entry.title),
              url: entry_url,
              summary: entry_summary[0..-11],
              content: img_and_article_body[:article_body],
              img: img_and_article_body[:img]
            }
            Article.create!(article_attr)
          end
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
