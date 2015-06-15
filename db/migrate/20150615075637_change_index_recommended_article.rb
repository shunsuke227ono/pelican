class ChangeIndexRecommendedArticle < ActiveRecord::Migration
  def change
    remove_index :recommended_articles, :article_id
    add_index :recommended_articles, :article_id, unique: false
  end
end
