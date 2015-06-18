namespace :rss do
  desc "get rss basic information and store it to db"
  def only_text(original_html)
    Nokogiri::HTML(original_html).inner_text
  end
  def update_summary?(article, entry_summary)
    article.summary != entry_summary
  end
  def store_similar_entries(category)
    ActiveRecord::Base.transaction do
      p "========= start get similar_article of #{category} =========="
      Settings.rss.yahoo.try(category).each do |rss_url|
        category_id = SimilarArticle.categories[category]
        feed = Feedjira::Feed.fetch_and_parse rss_url
        feed.entries.each do |entry|
          next if SimilarArticle.find_by(category: category_id, url: entry.url).present?
          SimilarArticle.create!(
            category: category_id,
            title: only_text(entry.title),
            url: only_text(entry.url),
            #summary: only_text(entry.summary),
            content: FullContent.article_body(entry.url)
          )
        end
      end
    end
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
            img_and_article_body = FullContent.img_and_article_body(entry.url)
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
  # 以下関連記事取得task
  task :get_similar_top => :environment do
    store_similar_entries(:top)
  end
  task :get_similar_dom => :environment do
    store_similar_entries(:dom)
  end
  task :get_similar_int => :environment do
    store_similar_entries(:int)
  end
  task :get_similar_eco => :environment do
    store_similar_entries(:eco)
  end
  task :get_similar_ent => :environment do
    store_similar_entries(:ent)
  end
  task :get_similar_spo => :environment do
    store_similar_entries(:spo)
  end
  task :get_similar_mov => :environment do
    store_similar_entries(:mov)
  end
  task :get_similar_gourmet => :environment do
    store_similar_entries(:gourmet)
  end
  task :get_similar_love => :environment do
    store_similar_entries(:love)
  end
  task :get_similar_trend => :environment do
    store_similar_entries(:trend)
  end
end
