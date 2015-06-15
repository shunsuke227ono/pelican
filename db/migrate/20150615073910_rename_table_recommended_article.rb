class RenameTableRecommendedArticle < ActiveRecord::Migration
  def change
    rename_table :recommedned_articles, :recommended_articles
  end
end
