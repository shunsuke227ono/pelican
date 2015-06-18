namespace :similarity do
  desc "calculate similarity of articles and store it to livedoor article db"
  def set_similar_articles(category)
    p "=========start sim #{category}=========="
    # それぞれの記事を形態素のarrayに
    category_id = Article.categories[category]
    articles = []
    all_articles_morpheme = []
    nm = NattoMecab.new
    livedoor_articles = Article.where(category: category_id, has_recommendation: false)
    livedoor_articles.each do |article|
      articles << { class_name: "Article", id: article.id}
      all_articles_morpheme << nm.nouns(article.content)
    end
    if category == :top
      Article.categories.each_pair do |key, val|
        category_id = val
        SimilarArticle.where(category: category_id).last(Settings.num_of_comparisons.try(category)).each do |article|
          articles << { class_name: "SimilarArticle", id: article.id }
          all_articles_morpheme << nm.nouns(article.content)
        end
      end
    else
      SimilarArticle.where(category: category_id).last(Settings.num_of_comparisons.try(category)).each do |article|
        articles << { class_name: "SimilarArticle", id: article.id }
        all_articles_morpheme << nm.nouns(article.content)
      end
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
  task :get_similar_articles_top => :environment do
    set_similar_articles(:top)
  end
  task :get_similar_articles_dom => :environment do
    set_similar_articles(:dom)
  end
  task :get_similar_articles_int => :environment do
    set_similar_articles(:int)
  end
  task :get_similar_articles_eco => :environment do
    set_similar_articles(:eco)
  end
  task :get_similar_articles_ent => :environment do
    set_similar_articles(:ent)
  end
  task :get_similar_articles_spo => :environment do
    set_similar_articles(:spo)
  end
  task :get_similar_articles_mov => :environment do
    set_similar_articles(:mov)
  end
  task :get_similar_articles_gourmet => :environment do
    set_similar_articles(:gourmet)
  end
  task :get_similar_articles_love => :environment do
    set_similar_articles(:love)
  end
  task :get_similar_articles_trend => :environment do
    set_similar_articles(:trend)
  end
end
