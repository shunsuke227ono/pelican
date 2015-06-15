class RemoveColumnFromRecommendedArticles < ActiveRecord::Migration
  def change
    remove_column :recommended_articles, :first_similar_article_id
    remove_column :recommended_articles, :second_similar_article_id
    remove_column :recommended_articles, :third_similar_article_id
    add_column :recommended_articles, :similar_article_id, :integer
  end
end
