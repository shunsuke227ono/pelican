class CreateSimilarArticles < ActiveRecord::Migration
  def change
    create_table :similar_articles do |t|
      t.integer :category
      t.string :title
      t.text :summary
      t.text :content
      t.string :url
      t.timestamps null: false
    end
    add_index :similar_articles, ["category", "url"], unique: true
  end
end
