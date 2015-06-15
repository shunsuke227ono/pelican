class AddHasRecommendationColumnToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :has_recommendation, :bool

  end
end
