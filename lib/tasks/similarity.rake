namespace :similarity do
  desc "calculate similarity of articles and store it to livedoor article db"
  task :get_similar_articles => :environment do
    Article.categories.each do |category|
      p "=========start sim #{category}=========="
      # それぞれの記事を形態素のarrayに
      category_id = category[1]
      articles = []
      all_articles_morpheme = []
      nm = NattoMecab.new
      livedoor_articles = Article.where(category: category_id, has_recommendation: false)
      livedoor_articles.each do |article|
        articles << { class_name: "Article", id: article.id}
        all_articles_morpheme << nm.nouns(article.content)
      end
      # 現状 7x20=140の最新記事取得している。最新からのみ類似選ぶ。
      SimilarArticle.where(category: category_id).last(100).each do |article|
        articles << { class_name: "SimilarArticle", id: article.id }
        all_articles_morpheme << nm.nouns(article.content)
      end

      similar_article_base_index = livedoor_articles.size
      tfidf = TfIdfCalculation.new(all_articles_morpheme, similar_article_base_index)
      articles[0...similar_article_base_index].each_with_index do |article, index|
        recommended_articles = RecommendedArticle.where(article_id: article[:id])
        three_closest_article_indexes = tfidf.three_closest_cos_distance_indexes_from(index)
        three_closest_article_indexes.each_with_index do |closest_index, i|
          if i < recommended_articles.size
            recommended_articles[i].update!(similar_article_id: articles[closest_index][:id])
          else
            RecommendedArticle.create!(article_id: article[:id], similar_article_id: articles[closest_index][:id])
          end
        end
        livedoor_articles[index].update!(has_recommendation: true)
      end
    end
  end
end
