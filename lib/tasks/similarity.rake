namespace :similarity do
  desc "calculate similarity of articles and store it to livedoor article db"
  task :calculate => :environment do
    Article.categories.each do |category|
      ActiveRecord::Base.transaction do
        # それぞれの記事を形態素のarrayに
        next unless category[0] == "spo"
        category_id = category[1]
        articles = []
        all_articles_morpheme = []
        nm = NattoMecab.new
        livedoor_articles = Article.where(category: category_id)
        livedoor_articles.each do |article|
          articles << { class_name: "Article", id: article.id}
          all_articles_morpheme << nm.nouns(article.content)
        end
        SimilarArticle.where(category: category_id).each do |article|
          articles << { class_name: "SimilarArticle", id: article.id }
          all_articles_morpheme << nm.nouns(article.content)
        end
        
        similar_article_base_index = livedoor_articles.size
        tfidf = TfIdfCalculation.new(all_articles_morpheme, similar_article_base_index)
        articles[0...similar_article_base_index].each_with_index do |article, index|
          three_closest_article_indexes = tfidf.three_closest_cos_distance_indexes_from(index)
          three_closest_article_indexes.each do |index|
            p articles[index]
          end
          # FIXME 全記事内から類似三つだが、livedoor内からは持ってこないで
        end
      end
    end
  end
end
