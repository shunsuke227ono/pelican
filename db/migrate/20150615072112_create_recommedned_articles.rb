class CreateRecommednedArticles < ActiveRecord::Migration
  def change
    create_table :recommedned_articles do |t|
      t.integer :article_id
      t.integer :first_similar_article_id
      t.integer :second_similar_article_id
      t.integer :third_similar_article_id
      t.timestamps null: false
    end
    add_index :recommedned_articles, :article_id, unique: true
  end
end
