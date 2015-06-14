namespace :similarity do
  desc "calculate similarity of articles and store it to livedoor article db"
  task :calculate => :environment do
    Article.categories.each do |category|
      ActiveRecord::Base.transaction do
        # それぞれの記事を形態素のarrayに
        next unless category[0] == "spo"
        category_id = category[1]
        article_ids = []
        all_articles_morpheme = []
        nm = Natto::MeCab.new('-F%m,\s%f[0]')
        Article.where(category: category_id).each do |article|
          article_ids << { class_name: "Article", id: article.id}
          all_articles_morpheme << nm.enum_parse(article.content).map{ |x| x.surface if x.feature[-2..-1]=="名詞"||x.feature[-2..-1]=="動詞" }.compact
        end
        SimilarArticle.where(category: category_id).each do |article|
          article_ids << { class_name: "SimilarArticle", id: article.id }
          all_articles_morpheme << nm.enum_parse(article.content).map{ |x| x.surface if x.feature[-2..-1]=="名詞"||x.feature[-2..-1]=="動詞" }.compact
        end

        tfidf = TfIdf.new(all_articles_morpheme)
        tfidf_hashes = tfidf.tf_idf # array of hash

        # それぞれのベクトルにとって類似度トップ探す。
        # O(n^2)
        tfidf_vectors = tfidf_hashes.map{ |tfidf_hash| tfidf_hash.values }# 特徴ベクトルのarray
        distance_matrix = [];
        tfidf_vectors.each do |origin_vector|
          p origin_vector.size
          #distance_matrix_row = []
          #tfidf_vectors.each do |goal_vector|
          #  distance_matrix_row << VectorCalculation.cos_of(origin_vector, goal_vector)
          #end
          #distance_matrix << distance_matrix_row
        end
      end
    end
  end
end
